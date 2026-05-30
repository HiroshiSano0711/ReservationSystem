module Admin
  class ReservationsController < Admin::BaseController
    def index
      @reservations = @team.reservations.order(:start_time)
    end

    def show
      @reservation = Reservation.find_by!(public_id: params[:public_id])
      @cancellable = ReservationRules::CancelPolicy.new(@reservation).valid?
    end

    def cancel
      reservation = Reservation.find_by!(public_id: params[:public_id])
      result = Services::Reservations::Cancel.new(
        reservation: reservation,
        customer: nil
      ).call

      if result.success?
        ReservationStatusLog.create!(
          reservation: reservation,
          from_status: :finalized,
          to_status: :canceled,
          changed_by: :admin
        )
        redirect_to admin_reservation_path(public_id: reservation.public_id), notice: "予約をキャンセルしました"
      else
        redirect_to admin_reservation_path(public_id: reservation.public_id), alert: result.message
      end
    end
  end
end

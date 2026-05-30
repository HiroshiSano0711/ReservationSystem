module Admin
  class ReservationsController < Admin::BaseController
    def index
      @reservations = @team.reservations.order(:start_time)
    end

    def show
      @reservation = Reservation.find_by!(public_id: params[:public_id])
    end

    def cancel
      reservation = Reservation.find_by!(public_id: params[:public_id])
      service = Services::Reservations::Cancel.new(
        reservation: reservation,
        customer: nil
      )
      result = service.call(admin: true)
      if result.success?
        redirect_to admin_reservation_path(public_id: reservation.public_id), notice: "予約をキャンセルしました"
      else
        redirect_to admin_reservation_path(public_id: reservation.public_id), alert: result.message
      end
    end
  end
end

module Admin
  class ReservationsController < Admin::BaseController
    def index
      @reservations = @team.reservations.order(:start_time)
    end

    def show
      @reservation = Reservation.find_by!(public_id: params[:public_id])
      @cancellable = Reservations::Rules::CancelPolicy.new(@reservation).validate.valid?
    end

    def cancel
      reservation = Reservation.find_by!(public_id: params[:public_id])
      result = Services::Reservations::Cancel.new(
        reservation: reservation,
        actor: :admin
      ).call

      if result.success?
        redirect_to admin_reservation_path(public_id: reservation.public_id), notice: "予約をキャンセルしました"
      else
        redirect_to admin_reservation_path(public_id: reservation.public_id), alert: "システムエラーが発生しました。お手数ですが管理者へお問い合わせください。"
      end
    end
  end
end

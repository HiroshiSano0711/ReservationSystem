class Mypage::ReservationsController < ApplicationController
  before_action :authenticate_customer!

  def index
    @customer = current_customer
    @reservations = current_customer.reservations.order(date: :desc, start_time: :desc)
  end

  def show
    @reservation = current_customer.reservations.find_by(public_id: params[:public_id])
  end

  def cancel
    reservation = current_customer.reservations.find_by(public_id: params[:public_id])
    service = Reservations::CancelService.new(reservation: reservation, customer: current_customer)
    result = service.call

    if result.success?
      ReservationCanceledNotifier.send(
          context: {
            current_customer: current_customer,
            admin_staff: result.data.team.admin_staff
          },
          attr: result.data
        )
      redirect_to mypage_reservations_path, notice: "予約をキャンセルしました。"
    else
      redirect_to mypage_reservation_path(public_id: reservation.public_id), alert: "キャンセルできませんでした。#{result.message}"
    end
  end
end

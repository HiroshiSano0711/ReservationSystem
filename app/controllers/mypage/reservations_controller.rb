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
      NotificationSender.new(
        team: result.data.team,
        reservation: result.data,
        notification_type: :reservation_canceled
      ).call

      redirect_to mypage_reservations_path, notice: "予約をキャンセルしました。"
    else
      redirect_to mypage_reservation_path(public_id: reservation.public_id), alert: "キャンセルできませんでした。#{result.message}"
    end
  end
end

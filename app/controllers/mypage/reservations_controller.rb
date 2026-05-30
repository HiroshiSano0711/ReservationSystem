module Mypage
  class ReservationsController < ApplicationController
    before_action :authenticate_customer!

    def index
      @customer = current_customer
      @reservations = current_customer.reservations.order(date: :desc, start_time: :desc)
    end

    def show
      @reservation = current_customer.reservations.find_by(public_id: params[:public_id])
      @cancellable = ReservationRules::CancelPolicy.new(@reservation).valid?
    end

    def cancel
      reservation = current_customer.reservations.find_by(public_id: params[:public_id])
      result = Services::Reservations::Cancel.new(
        reservation: reservation,
        customer: current_customer
      ).call

      if result.success?
        ReservationStatusLog.create!(
          reservation: reservation,
          from_status: :finalized,
          to_status: :canceled,
          changed_by: :customer
        )
        NotificationSender.new(
          team: result.resource.team,
          reservation: result.resource,
          notification_type: :reservation_canceled
        ).call

        redirect_to mypage_reservations_path, notice: "予約をキャンセルしました。"
      else
        redirect_to mypage_reservation_path(public_id: reservation.public_id), alert: "キャンセルできませんでした。#{result.message}"
      end
    end
  end
end

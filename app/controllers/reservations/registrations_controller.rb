module Reservations
  class RegistrationsController < ApplicationController
    def new
      @reservation = Reservation.find_by!(public_id: params[:public_id])
      @customer = @reservation.customer
    end

    def create
      @reservation = Reservation.find_by!(public_id: params[:public_id])

      registrar = Customers::ConfirmReservationRegistrar.new(
        reservation: @reservation,
        phone_number: params[:customer][:phone_number],
        customer_params: customer_params
      )

      if registrar.call
        redirect_to root_path, notice: '確認メールを送信しました。メールに記載されている認証URLをクリックしてください。'
      else
        @customer = @reservation.customer
        flash.now[:alert] = registrar.errors.flatten.join(',')
        render :new
      end
    end

    private

    def customer_params
      params.require(:customer).permit(:email, :password, :password_confirmation)
    end
  end
end

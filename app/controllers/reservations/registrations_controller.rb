module Reservations
  class RegistrationsController < ApplicationController
    def new
      @reservation = Reservation.find_by!(public_id: params[:public_id])
      @customer = @reservation.customer
    end

    def create
      @reservation = Reservation.find_by!(public_id: params[:public_id])
      if @reservation.customer_phone_number === customer_params[:phone_number] && customer_params[:email].match? URI::MailTo::EMAIL_REGEXP
        Customer.invite!(email: customer_params[:email])
        redirect_to root_path, notice: "招待メールを送信しました。メールに記載されているURLから登録してください。"
      else
        flash.now[:alert] = "電話番号が一致しないかメールアドレスの形式が間違えています。入力内容をご確認ください。"
        render :new
      end
    end

    private

    def customer_params
      params.require(:customer).permit(:email, :phone_number)
    end
  end
end

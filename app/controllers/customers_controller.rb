class CustomersController < ApplicationController
  def new
    @customer = Customer.new
  end

  def invite
    Customer.invite!(email: staff_params[:email])
    redirect_to root_path, notice: 'メールアドレスへ招待メールを送信しました。'
  end

  private

  def staff_params
    params.require(:customer).permit(:email)
  end
end

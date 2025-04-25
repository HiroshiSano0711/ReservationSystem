class CustomersController < ApplicationController
  def new
    @customer = Customer.new
  end

  def invite
    if customer_params[:email].match? URI::MailTo::EMAIL_REGEXP
      Customer.invite!(email: customer_params[:email])
      redirect_to root_path, notice: "メールアドレスへ登録メールを送信しました"
    else
      @customer = Customer.new(email: customer_params[:email])
      flash[:alert] = "メールアドレスの形式ではありません。入力内容をご確認ください"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:email)
  end
end

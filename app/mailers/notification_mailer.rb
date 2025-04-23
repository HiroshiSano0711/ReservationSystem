class NotificationMailer < ApplicationMailer
  default from: "no-reply@example.com"

  def reservation_created(receiver:, reservation:, action_url:)
    @reservation = reservation
    @action_url = action_url
    mail(to: receiver.email, subject: "新しい予約が入りました")
  end

  def reservation_canceled(receiver:, reservation:, action_url:)
    @reservation = reservation
    @action_url = action_url
    mail(to: receiver.email, subject: "予約がキャンセルされました")
  end
end

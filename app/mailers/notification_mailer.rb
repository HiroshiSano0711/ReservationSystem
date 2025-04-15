class NotificationMailer < ApplicationMailer
  def reservation_created(notification:, sender_email:, receiver_email:)
    @notification = notification
    mail(from: sender_email, to: receiver_email, subject: "新しい予約が入りました")
  end

  def reservation_canceled(notification:, sender_email:, receiver_email:)
    @notification = notification
    mail(from: sender_email, to: receiver_email, subject: "予約がキャンセルされました")
  end
end

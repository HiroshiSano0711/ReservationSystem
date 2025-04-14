class NotificationMailer < ApplicationMailer
  default from: "no-reply@example.com"

  def reservation_created(notification, context)
    @notification = notification
    mail(to: context[:admin_staff].email, subject: "新しい予約が入りました")
  end

  def reservation_canceled(notification)
    @notification = notification
    mail(to: context[:admin_staff].email, subject: "予約がキャンセルされました")
  end
end

class NotificationSender
  def self.send(notification, context)
    case notification.notification_type_before_type_cast
    when Notification.notification_types[:reservation_created]
      send_reservation_created(notification, context)
    when Notification.notification_types[:reservation_canceled]
      send_reservation_canceled(notification, context)
    else
      Rails.logger.error("Unknown notification type: #{notification.notification_type}")
    end
  rescue => e
    Rails.logger.error("[NotificationSenderError] #{e.class} - #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
  end

  private

  def self.send_reservation_created(notification, context)
    NotificationMailer.reservation_created(
      notification: notification,
      sender_email: context[:sender].email,
      receiver_email: context[:receiver].email
    ).deliver_later
  end

  def self.send_reservation_canceled(notification, context)
    NotificationMailer.reservation_canceled(
      notification: notification,
      sender_email: context[:sender].email,
      receiver_email: context[:receiver].email
    ).deliver_later
  end
end

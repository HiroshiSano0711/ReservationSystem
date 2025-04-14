class NotificationSender
  def self.send(notification, context)
    case notification.notification_type
    when "reservation_created"
      send_reservation_created(notification, context)
    when "reservation_canceled"
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
    NotificationMailer.reservation_created(notification, context).deliver_later

    # 後ほどリアルタイムにしたい。いまはメール通知と管理画面で通知バッジを点灯させるだけ。
    # NotificationChannel.broadcast_to(notification.receiver_id, message: notification.message)
  end

  def self.send_reservation_canceled(notification)
    # NotificationChannel.broadcast_to(notification.receiver_id, message: notification.message)
  end
end

class NotificationDecorator < Draper::Decorator
  delegate_all

  def human_enum_notification_type
    I18n.t("activerecord.enums.#{object.model_name.i18n_key}.notification_type.#{object.notification_type}")
  end

  def human_is_read
     object.is_read ? "既読" : "未読"
  end

  def message
    if object.reservation_created?
      "#{object.reservation.customer_name}さんから予約が入りました。"
    elsif object.reservation_canceled?
      "#{object.reservation.customer_name}さんが予約をキャンセルしました。"
    end
  end
end

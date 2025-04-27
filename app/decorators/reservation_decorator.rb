class ReservationDecorator < Draper::Decorator
  delegate_all

  def reserve_date
    object.date.strftime('%Y年%m月%d日')
  end

  def reserve_time
    "#{object.start_time.strftime("%H:%M")}~#{object.end_time.strftime("%H:%M")}"
  end

  def reserve_datetime
    "#{object.date.strftime('%Y年%m月%d日')} #{object.start_time.strftime("%H:%M")}~#{object.end_time.strftime("%H:%M")}"
  end

  def total_duration_with_unit
    "#{object.total_duration}分"
  end

  def human_enum_status
    I18n.t("activerecord.enums.#{object.model_name.i18n_key}.status.#{object.status}")
  end
end

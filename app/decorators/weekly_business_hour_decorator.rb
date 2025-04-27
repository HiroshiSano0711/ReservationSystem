class WeeklyBusinessHourDecorator < Draper::Decorator
  delegate_all

  def human_enum_wday
    I18n.t("activerecord.enums.#{object.model_name.i18n_key}.wday.#{object.wday}")
  end

  def open_str
    object.open.strftime('%H:%M')
  end

  def close_str
    object.close.strftime('%H:%M')
  end

  def open_close
    "#{object.open.strftime("%H:%M")}~#{object.close.strftime("%H:%M")}"
  end
end

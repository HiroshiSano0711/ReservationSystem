class StaffProfileDecorator < Draper::Decorator
  delegate_all

  def human_accepts_direct_booking
    object.accepts_direct_booking ? '受付ける' : '受け付けない'
  end

  def human_enum_working_status
    I18n.t("activerecord.enums.#{object.model_name.i18n_key}.working_status.#{object.working_status}")
  end
end

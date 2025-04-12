module ApplicationHelper
  def enum_options_for_select_from(model_class, attr)
    model_class.send(attr.to_s.pluralize).keys.map do |key|
      [I18n.t("activerecord.enums.#{model_class.model_name.i18n_key}.#{attr}.#{key}"), key]
    end
  end
end

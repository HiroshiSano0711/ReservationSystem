module FormObjectHelper
  def model_label(form_builder, attr, options = {})
    form_obj = form_builder.object
    model_class = form_obj.model_class_for(attr)
    label_text = model_class.human_attribute_name(attr, default: attr.to_s.humanize)

    form_builder.label(attr, label_text, options)
  end

  def enum_options_for_select(form_builder, attr)
    form_obj = form_builder.object
    model_class = form_obj.model_class_for(attr)
    model_class.send(attr.to_s.pluralize).keys.map do |key|
      [ I18n.t("activerecord.enums.#{model_class.model_name.i18n_key}.#{attr}.#{key}"), key ]
    end
  end
end

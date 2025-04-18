module FormLabelHelper
  def model_label(form_builder, attr, options = {})
    form = form_builder.object
    model_class = form.model_class_for(attr)
    label_text = model_class.human_attribute_name(attr, default: attr.to_s.humanize)

    form_builder.label(attr, label_text, options)
  end
end

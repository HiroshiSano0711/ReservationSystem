require 'rails_helper'

RSpec.describe FormObjectHelper, type: :helper do
  describe '#model_label' do
    let(:form_builder) { double('FormBuilder') }
    let(:form_object) { double('FormObject') }
    let(:model_class) { double('ModelClass') }

    before do
      allow(form_builder).to receive(:object).and_return(form_object)
      allow(form_object).to receive(:model_class_for).and_return(model_class)
      allow(model_class).to receive(:human_attribute_name).with(:name, default: 'Name').and_return('Name')
      allow(form_builder).to receive(:label).with(:name, 'Name', {}).and_return('<label>Name</label>'.html_safe)
    end

    it 'returns a label tag with the correct text' do
      result = helper.model_label(form_builder, :name)
      expect(result).to eq('<label>Name</label>')
    end
  end

  describe '#enum_options_for_select' do
    let(:form_builder) { double('FormBuilder') }
    let(:form_object) { double('FormObject') }
    let(:model_class) { double('ModelClass') }

    before do
      allow(form_builder).to receive(:object).and_return(form_object)
      allow(form_object).to receive(:model_class_for).and_return(model_class)
    end

    context 'when attribute is an enum' do
      it 'returns correct enum options' do
        model_name_double = double('ModelName', i18n_key: 'model_class')
        allow(model_class).to receive(:model_name).and_return(model_name_double)
        enum_values = { active: 1, inactive: 0 }
        allow(model_class).to receive(:statuses).and_return(enum_values)
        allow(I18n).to receive(:t).with('activerecord.enums.model_class.statuses.active').and_return('Active')
        allow(I18n).to receive(:t).with('activerecord.enums.model_class.statuses.inactive').and_return('Inactive')

        result = helper.enum_options_for_select(form_builder, :statuses)

        expect(result).to eq([
          ['Active', :active],
          ['Inactive', :inactive]
        ])
      end
    end
  end
end

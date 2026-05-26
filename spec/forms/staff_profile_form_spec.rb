require 'rails_helper'

RSpec.describe StaffProfileForm, type: :model do
  let(:staff) { create(:staff, :with_profile) }
  let(:service_menus) { create_list(:service_menu, 3, team: staff.team) }
  let(:form) { described_class.new(staff_profile: staff.staff_profile, service_menus: service_menus) }

  describe '#model_class_for' do
    it 'returns StaffProfile for staff profile attributes' do
      expect(form.model_class_for(:nick_name)).to eq(StaffProfile)
    end
  end

  describe '#valid?' do
    it 'is valid with correct input' do
      form.nick_name = 'Test Nickname'
      form.selected_service_menu_ids = service_menus.map(&:id)

      expect(form.valid?).to be true
    end

    it 'is invalid without a nick_name' do
      form.nick_name = ''

      expect(form.valid?).to be false
      expect(form.errors[:nick_name]).to be_present
    end

    it 'service_menus_belong_to_team' do
      other_team = create(:team)
      other_team_service_menu = create(:service_menu, team: other_team)
      form.selected_service_menu_ids = [ other_team_service_menu.id ]

      expect(form.valid?).to be false
      expect(form.errors[:selected_service_menu_ids]).to include('サービスメニューに無効な選択肢があります')
    end
  end
end

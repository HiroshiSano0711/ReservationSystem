require 'rails_helper'

RSpec.describe Reservations::SelectMenuAndStaffForm, type: :model do
  let(:team) { create(:team) }
  let(:form) { described_class.new(team: team) }

  describe '#initialize' do
    it 'loads only staff_profiles where accepts_direct_booking is true' do
      staff_1 = create(:staff, team: team)
      staff_2 = create(:staff, team: team)
      should_include_profile = create(:staff_profile, staff: staff_1, accepts_direct_booking: true)
      should_not_include_profile = create(:staff_profile, staff: staff_2, accepts_direct_booking: false)

      new_form = described_class.new(team: team)

      expect(new_form.staff_profiles).to include(should_include_profile)
      expect(new_form.staff_profiles).to_not include(should_not_include_profile)
    end
  end

  describe '#persisted?' do
    it 'returns false' do
      expect(form.persisted?).to eq(false)
    end
  end

  describe 'validations' do
    context 'when single_menu_ids is not an array' do
      it 'is invalid' do
        form.single_menu_ids = 'invalid'

        expect(form.valid?).to eq false
        expect(form.errors[:single_menu_ids]).to include('は不正な形式です')
      end
    end

    context 'when no menu is selected' do
      it 'is invalid' do
        form.single_menu_ids = []
        form.multi_staff_menu_id = nil

        expect(form).to be_invalid
        expect(form.errors[:single_menu_ids]).to include('を1つ選択してください。')
      end
    end

    context 'when both single and multi staff menus are selected' do
      it 'is invalid' do
        single_menu = create(:service_menu, team: team, required_staff_count: 1, available_from: FIXED_TIME.call)
        multi_menu = create(:service_menu, team: team, required_staff_count: 2, available_from: FIXED_TIME.call)

        form.single_menu_ids = [single_menu.id]
        form.multi_staff_menu_id = multi_menu.id

        expect(form).to be_invalid
        expect(form.errors[:multi_staff_menu_id]).to include('は単独対応メニューと同時に選択できません。')
      end
    end

    context 'when only single staff menu is selected' do
      it 'is valid' do
        single_menu = create(:service_menu, team: team, required_staff_count: 1, available_from: FIXED_TIME.call)
        form.single_menu_ids = [single_menu.id]
        form.multi_staff_menu_id = nil

        expect(form).to be_valid
      end
    end

    context 'when only multi staff menu is selected' do
      it 'is valid' do
        form.single_menu_ids = []
        multi_menu = create(:service_menu, team: team, required_staff_count: 2, available_from: FIXED_TIME.call)
        form.multi_staff_menu_id = multi_menu.id

        expect(form).to be_valid
      end
    end
  end

  describe '#single_staff_menus' do
    it 'returns only single staff menus' do
      single_menu = create(:service_menu, team: team, required_staff_count: 1, available_from: FIXED_TIME.call)
      create(:service_menu, team: team, required_staff_count: 2, available_from: FIXED_TIME.call)

      expect(form.single_staff_menus).to match_array([single_menu])
    end
  end

  describe '#multi_staff_menus' do
    it 'returns only multi staff menus' do
      create(:service_menu, team: team, required_staff_count: 1, available_from: FIXED_TIME.call)
      multi_menu = create(:service_menu, team: team, required_staff_count: 2, available_from: FIXED_TIME.call)

      expect(form.multi_staff_menus).to match_array([multi_menu])
    end
  end
end

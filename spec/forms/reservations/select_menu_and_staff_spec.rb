require 'rails_helper'

RSpec.describe Forms::Reservations::SelectMenuAndStaff, type: :model do
  let(:team) { create(:team) }
  let(:form) { described_class.new(team: team) }
  let(:time_curernt) { Time.zone.local(2025, 1, 1, 9, 0, 0) }

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
        single_menu = create(:service_menu, team: team, required_staff_count: 1, available_from: time_curernt)
        multi_menu = create(:service_menu, team: team, required_staff_count: 2, available_from: time_curernt)

        form.single_menu_ids = [ single_menu.id ]
        form.multi_staff_menu_id = multi_menu.id

        expect(form).to be_invalid
        expect(form.errors[:multi_staff_menu_id]).to include('は単独対応メニューと同時に選択できません。')
      end
    end

    context 'when only single staff menu is selected' do
      it 'is valid' do
        single_menu = create(:service_menu, team: team, required_staff_count: 1, available_from: time_curernt)
        form.single_menu_ids = [ single_menu.id ]
        form.multi_staff_menu_id = nil

        expect(form).to be_valid
      end
    end

    context 'when only multi staff menu is selected' do
      it 'is valid' do
        form.single_menu_ids = []
        multi_menu = create(:service_menu, team: team, required_staff_count: 2, available_from: time_curernt)
        form.multi_staff_menu_id = multi_menu.id

        expect(form).to be_valid
      end
    end
  end

  describe '#single_staff_menus' do
    it 'returns only single staff menus' do
      single_menu = create(:service_menu, team: team, required_staff_count: 1, available_from: time_curernt)
      create(:service_menu, team: team, required_staff_count: 2, available_from: time_curernt)

      expect(form.single_staff_menus).to match_array([ single_menu ])
    end
  end

  describe '#multi_staff_menus' do
    it 'returns only multi staff menus' do
      create(:service_menu, team: team, required_staff_count: 1, available_from: time_curernt)
      multi_menu = create(:service_menu, team: team, required_staff_count: 2, available_from: time_curernt)

      expect(form.multi_staff_menus).to match_array([ multi_menu ])
    end
  end
end

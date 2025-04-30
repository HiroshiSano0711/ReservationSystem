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
    it 'is valid with valid attributes' do
      form.nick_name = 'Test Nickname'
      form.selected_service_menu_ids = service_menus.map(&:id)

      expect(form.valid?).to be true
    end

    it 'is invalid without a nick_name' do
      form.nick_name = ''

      expect(form.valid?).to be false
      expect(form.errors[:nick_name]).to be_present
    end

    it 'is invalid with an invalid service_menu_id' do
      other_team = create(:team)
      other_team_service_menu = create(:service_menu, team: other_team)
      form.selected_service_menu_ids = [other_team_service_menu.id]

      expect(form.valid?).to be false
      expect(form.errors[:base]).to include('サービスメニューに無効な選択肢があります')
    end
  end

  describe '#save' do
    let(:params) do
      {
        nick_name: 'Updated Nickname',
        working_status: 'active',
        accepts_direct_booking: true,
        bio: 'New bio',
        selected_service_menu_ids: service_menus.map(&:id)
      }
    end

    context 'with valid params' do
      it 'return true' do
        form.assign_attributes(params)

        expect(form.save).to be true
      end

      it 'updates the staff profile and service menus' do
        form.assign_attributes(params)

        expect {
          form.save
        }.to change { staff.reload.staff_profile.nick_name }.to('Updated Nickname')
         .and change { staff.service_menus.count }.to(service_menus.count)
      end

      it 'updates the diff service menus' do
        staff.service_menus << service_menus
        staff.save!
        params[:selected_service_menu_ids] = [ service_menus.first.id ]
        form.assign_attributes(params)

        expect {
          form.save
        }.to change { staff.service_menus.count }.to(1)
      end
    end

    context 'with invalid params' do
      it 'does not save and returns false' do
        params[:nick_name] = ''
        form.assign_attributes(params)

        expect(form.save).to be false
      end
    end

    context 'when an exception occurs during save' do
      it 'rescues and returns false' do
        allow_any_instance_of(StaffProfile).to receive(:update!).and_raise(ActiveRecord::RecordInvalid)
        form.assign_attributes(params)

        expect(form.save).to be false
      end
    end
  end
end

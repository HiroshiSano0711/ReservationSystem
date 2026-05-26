require 'rails_helper'

RSpec.describe UpdateStaffProfile, type: :model do
  let(:staff) { create(:staff, :with_profile) }
  let(:service_menus) { create_list(:service_menu, 3, team: staff.team) }
  let(:form) { StaffProfileForm.new(staff_profile: staff.staff_profile) }

  describe 'validate' do
    it 'service_menus_belong_to_team' do
      other_team = create(:team)
      other_team_service_menu = create(:service_menu, team: other_team)
      form.selected_service_menu_ids = [ other_team_service_menu.id ]

      result = described_class.new(staff, form, service_menus).call
      expect(result.success?).to be false
      expect(form.errors).to be_present
      expect(form.errors[:selected_service_menu_ids]).to be_present
    end
  end

  describe '#call' do
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
        result = described_class.new(staff, form, service_menus).call
        expect(result.success?).to be true
      end

      it 'updates the staff profile and service menus' do
        form.assign_attributes(params)

        expect {
          result = described_class.new(staff, form, service_menus).call
        }.to change { staff.reload.staff_profile.nick_name }.to('Updated Nickname')
         .and change { staff.service_menus.count }.to(service_menus.count)
      end

      it 'updates the diff service menus' do
        staff.service_menus << service_menus
        staff.save!
        params[:selected_service_menu_ids] = [ service_menus.first.id ]
        form.assign_attributes(params)

        expect {
          result = described_class.new(staff, form, service_menus).call
        }.to change { staff.service_menus.count }.to(1)
      end
    end

    context 'with invalid params' do
      it 'does not save and returns false' do
        params[:nick_name] = ''
        form.assign_attributes(params)
        result = described_class.new(staff, form, service_menus).call
        expect(result.success?).to be false
      end
    end

    context 'when an exception occurs during save' do
      it 'rescues and returns false' do
        allow_any_instance_of(StaffProfile).to receive(:update!).and_raise(ActiveRecord::RecordInvalid)
        form.assign_attributes(params)

        result = described_class.new(staff, form, service_menus).call
        expect(result.success?).to be false
      end
    end
  end
end

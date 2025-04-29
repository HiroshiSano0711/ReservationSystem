require 'rails_helper'

RSpec.describe StaffProfileForm, type: :model do
  let(:staff) { create(:staff) }
  let(:service_menus) { create_list(:service_menu, 3, team: staff.team) }
  let(:form) { described_class.new(staff: staff, service_menus: service_menus) }

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
      form.selected_service_menu_ids = [9999] # 存在しないID
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
      it 'updates the staff profile and service menus' do
        expect {
          result = form.save(params)
          expect(result).to be true
        }.to change { staff.reload.staff_profile.nick_name }.to('Updated Nickname')
         .and change { staff.service_menus.count }.to(service_menus.count)
      end
    end

    context 'with invalid params' do
      it 'does not save and returns false' do
        params[:nick_name] = ''

        expect(form.save(params)).to be false
      end
    end

    context 'when an exception occurs during save' do
      it 'rescues and returns false' do
        allow_any_instance_of(StaffProfile).to receive(:update!).and_raise(ActiveRecord::RecordInvalid)

        expect(form.save(params)).to be false
      end
    end
  end
end

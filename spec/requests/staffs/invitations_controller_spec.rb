require 'rails_helper'

RSpec.describe Staffs::InvitationsController, type: :request do
  describe 'PATCH /staffs/invitation' do
    let(:team) { create(:team) }
    let(:staff) { Staff.invite!(email: 'test@example.com', team: team) }

    it 'creates a staff profile when invitation is accepted' do
      patch staff_invitation_path, params: {
        staff: {
          invitation_token: staff.raw_invitation_token,
          password: 'password123',
          password_confirmation: 'password123'
        }
      }

      expect(response).to redirect_to(root_path)
      expect(staff.reload.staff_profile).to be_present
    end
  end
end

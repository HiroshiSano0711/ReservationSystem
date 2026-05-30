RSpec.shared_context "admin access setup" do
  let(:team) { create(:team) }
  let(:admin) { create(:staff, :admin, team: team, invitation_accepted_at: Time.zone.local(2025, 1, 1, 9, 0, 0)) }
  let(:non_admin) { create(:staff, team: team, invitation_accepted_at: Time.zone.local(2025, 1, 1, 9, 0, 0)) }
  let(:not_accept_admin_staff) { create(:staff, :admin, team: team, invitation_accepted_at: nil) }
  let(:customer) { create(:customer) }
end

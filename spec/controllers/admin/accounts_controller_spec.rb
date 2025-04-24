require 'rails_helper'

RSpec.describe Admin::AccountsController, type: :controller do
  it "inherits from Admin::BaseController" do
    expect(described_class < Admin::BaseController).to be true
  end

  it "returns http success" do
    admin = create(:staff, role: :admin_staff, invitation_accepted_at: FIXED_TIME.call)
    sign_in admin, scope: :staff

    get :show
    expect(response).to have_http_status(:success)
  end
end

require "rails_helper"

RSpec.describe Admin::StaffsController, type: :request do
  include_context "admin access setup"

  before do
    sign_in admin, scope: :staff
  end

  describe "GET #show" do
    it "return success" do
      get admin_staffs_path(team_id: team.id)

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #new" do
    it "return success" do
      get new_admin_staff_path(team_id: team.id)

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /admin/staffs" do
    context "when post valid params" do
      let(:valid_params) { { staff: { email: "newstaff@example.com" } } }

      it "send invitation mail to staff" do
        expect {
          post admin_staffs_path(team_id: team.id), params: valid_params
        }.to change(ActionMailer::Base.deliveries, :count).by(1)

        expect(ActionMailer::Base.deliveries.last.to).to include("newstaff@example.com")
        expect(response).to redirect_to(admin_staffs_path)
      end
    end

    context "when post invalid email" do
      let(:invalid_params) { { staff: { email: "" } } }

      it "render new" do
        expect {
          post admin_staffs_path(team_id: team.id), params: invalid_params
        }.not_to change(ActionMailer::Base.deliveries, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end
  end
end

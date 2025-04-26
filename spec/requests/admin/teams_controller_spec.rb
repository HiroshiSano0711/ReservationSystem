require 'rails_helper'

RSpec.describe Admin::TeamsController, type: :request do
  include_context "admin access setup"

  describe "admin access" do
    it "inherits from Admin::BaseController" do
      expect(described_class < Admin::BaseController).to be true
    end

    it_behaves_like "admin-only access" do
      let(:path) { admin_team_path(team.id) }
    end

    it_behaves_like "admin-only access" do
      let(:path) { edit_admin_team_path(team.id) }
    end
  end

  describe "action" do
    before do
      sign_in admin, scope: :staff
    end

    describe "GET #show" do
      it "responds successfully" do
        get admin_team_path(admin.team.id)

        expect(response).to have_http_status(:success)
      end
    end

    describe "GET #edit" do
      it "responds successfully" do
        get edit_admin_team_path(admin.team.id)

        expect(response).to have_http_status(:success)
      end
    end

    describe "PATCH #update" do
      context "with valid parameters" do
        let(:team_params) do
          {
            name: "更新されたチーム名",
            description: "チームの説明文",
            phone_number: "0123456789",
            permalink: "new-permalink"
          }
        end

        it "updates the team and redirects" do
          patch admin_team_path(admin.team.id), params: { team: team_params }

          expect(team.reload.name).to eq("更新されたチーム名")
          expect(response).to redirect_to(admin_team_path(team))
          expect(flash[:notice]).to be_present
        end
      end

      context "with invalid parameters" do
        let(:invalid_params) { { name: "", phone_number: "" } }

        it "does not update the team and re-renders edit" do
          patch admin_team_path(admin.team.id), params: { team: invalid_params }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to render_template(:edit)
          expect(flash[:alert]).to be_present
        end
      end
    end
  end
end

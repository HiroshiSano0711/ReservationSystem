require 'rails_helper'

RSpec.describe Admin::TeamsController, type: :controller do
  let(:admin) { create(:staff, :admin_staff, invitation_accepted_at: FIXED_TIME.call) }
  let(:team) { admin.team }

  before do
    sign_in admin, scope: :staff
  end

  it "inherits from Admin::BaseController" do
    expect(described_class < Admin::BaseController).to be true
  end

  describe "GET #show" do
    it "responds successfully" do
      get :show, params: { id: admin.team.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #edit" do
    it "responds successfully" do
      get :edit, params: { id: admin.team.id }
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
        patch :update, params: { id: admin.team.id, team: team_params }
        expect(response).to redirect_to(admin_team_path(team))
        expect(flash[:notice]).to eq("チーム情報を更新しました。")
        expect(team.reload.name).to eq("更新されたチーム名")
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) { { name: "", phone_number: "" } }

      it "does not update the team and re-renders edit" do
        patch :update, params: { id: admin.team.id, team: invalid_params }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
        expect(flash[:alert]).to eq("更新に失敗しました。入力内容を確認してください。")
      end
    end
  end
end

require 'rails_helper'

RSpec.describe Admin::TeamBusinessSettingsController, type: :request do
  include_context "admin access setup"

  before do
    sign_in admin, scope: :staff
  end

  describe "GET #show" do
    it "returns success" do
      get admin_team_business_setting_path(admin.team)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #edit" do
    it "returns success" do
      get edit_admin_team_business_setting_path(admin.team)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH #update" do
    let(:team_business_setting) { team.team_business_setting }

    context "with valid params" do
      let(:valid_params) do
        {
          team_business_setting_form: {
            max_reservation_month: 2,
            reservation_start_delay_days: 1,
            cancellation_deadline_hours_before: 12,
            weekly_business_hours: {
              "0" => {
                wday: 'mon',
                working_day: '1',
                open: "10:00",
                close: "18:00"
              }
            }
          }
        }
      end

      it "updates and redirects with notice" do
        create(:weekly_business_hour, team_business_setting: team_business_setting, wday: 'mon')

        patch admin_team_business_setting_path(team), params: valid_params

        expect(response).to redirect_to(admin_team_business_setting_path(team))
        expect(flash[:notice]).to eq("保存しました")
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        {
          team_business_setting_form: {
            max_reservation_month: nil,
            reservation_start_delay_days: nil,
            cancellation_deadline_hours_before: nil,
            weekly_business_hours: []
          }
        }
      end

      it "renders edit with alert" do
        create(:weekly_business_hour, team_business_setting: team_business_setting, wday: 'mon')

        patch admin_team_business_setting_path(team), params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("更新に失敗しました")
      end
    end
  end
end

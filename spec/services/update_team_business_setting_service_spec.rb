require 'rails_helper'

RSpec.describe UpdateTeamBusinessSettingService, type: :model do
  let(:team) { create(:team) }
  let(:team_business_setting) { create(:team_business_setting, :with_weekly_business_hours, team: team) }

  describe '#call' do
    context 'when valid' do
      let(:params) do
        {
          max_reservation_month: 6,
          reservation_start_delay_days: 3,
          cancellation_deadline_hours_before: 24,
          weekly_business_hours_params: {
            "0" => { "wday" => "sun", "working_day" => "1", "open" => "10:00", "close" => "20:00" }
          }
        }
      end

      it 'saves the team business setting' do
        expect {
          described_class.new(
            team_business_setting: team_business_setting,
            attributes: params
          ).call
        }.to change { team_business_setting.reload.max_reservation_month }.from(3).to(6)
      end

      it 'saves weekly business hours' do
        result = described_class.new(
          team_business_setting: team_business_setting,
          attributes: params
        ).call

        expect(result.success?).to be_truthy

        team_business_setting.reload
        weekly_business_hour = team_business_setting.weekly_business_hours.find { |wbh| wbh.wday === "sun" }
        expect(weekly_business_hour.open.strftime("%H:%M")).to eq("10:00")
        expect(weekly_business_hour.close.strftime("%H:%M")).to eq("20:00")
      end
    end

    context 'when invalid' do
      let(:params) do
        { max_reservation_month: -1 }
      end

      it 'does not save the team business setting' do
        result = described_class.new(
          team_business_setting: team_business_setting,
          attributes: params
        ).call

        expect(result.success?).to be_falsey
        expect(result.message).to be_present
      end
    end
  end
end

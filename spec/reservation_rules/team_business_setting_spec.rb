require "rails_helper"

RSpec.describe ReservationRules::TeamBusinessSetting, type: :model do
  describe "#validate" do
    before do
      allow(Time.zone).to receive(:today).and_return(Time.zone.local(2025, 1, 1, 9, 0, 0).to_date)
    end

    let(:team) { create(:team) }

    describe "#validate_start_date" do
      it "adds an error if the start date is too early" do
        team_business_setting = create(:team_business_setting, team: team, reservation_start_delay_days: 1)
        reservation = build(:reservation, team: team, start_time: Time.zone.local(2025, 1, 1, 9, 0, 0))

        described_class.new(team_business_setting, reservation).validate
        possible_start_date = Time.zone.today + reservation.team.team_business_setting.reservation_start_delay_days.days

        expect(reservation.errors[:start_time]).to include("は#{possible_start_date.strftime("%Y年%m月%d日")}から受付しています")
      end
    end

    describe "#validate_end_date" do
      it "adds an error if the end date is too late" do
        team_business_setting = create(:team_business_setting, team: team)
        reservation = build(:reservation, team: team, end_time: Time.zone.today + team.team_business_setting.max_reservation_month.months + 1.day)

        described_class.new(team_business_setting, reservation).validate
        possible_end_date = Time.zone.today + reservation.team.team_business_setting.max_reservation_month.months

        expect(reservation.errors[:end_time]).to include("は#{possible_end_date.strftime("%Y年%m月%d日")}までしか受付していません")
      end
    end
  end
end

require "rails_helper"

RSpec.describe TeamBusinessSetting, type: :model do
  describe "associations" do
    it { should belong_to(:team) }
    it { should have_many(:weekly_business_hours).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:max_reservation_month) }
    it { should validate_presence_of(:reservation_start_delay_days) }
    it { should validate_presence_of(:cancellation_deadline_hours_before) }
    it { should validate_numericality_of(:max_reservation_month).only_integer.is_greater_than(0) }
    it { should validate_numericality_of(:reservation_start_delay_days).only_integer.is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:cancellation_deadline_hours_before).only_integer.is_greater_than_or_equal_to(0) }
  end

  describe 'public method' do
    let(:monday) { Date.commercial(2025, 1, 1) }
    let(:setting) { create(:team_business_setting) }

    describe "#weekly_business_hour_for" do
      it "returns the business hour for the given date" do
        weekly_business_hour = create(:weekly_business_hour, team_business_setting: setting, wday: monday.wday)

        expect(setting.weekly_business_hour_for(monday)).to eq(weekly_business_hour)
      end
    end

    describe "#working_day?" do
      it "returns true if the day is a working day" do
        create(:weekly_business_hour, team_business_setting: setting, wday: monday.wday, working_day: true)

        expect(setting.working_day?(monday)).to be true
      end

      it "returns false if the day is not a working day" do
        create(:weekly_business_hour, team_business_setting: setting, wday: monday.wday, working_day: false)

        expect(setting.working_day?(monday)).to be false
      end
    end

    describe "#opening_hours" do
      it "returns opening and closing times for the given date" do
        create(:weekly_business_hour,
          team_business_setting: setting,
          wday: monday.wday,
          open: "09:00",
          close: "18:00"
        )

        hours = setting.opening_hours(monday)
        expect(hours[:open].strftime("%H:%M")).to eq("09:00")
        expect(hours[:close].strftime("%H:%M")).to eq("18:00")
      end
    end
  end
end

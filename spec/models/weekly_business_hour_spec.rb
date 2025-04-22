require "rails_helper"

RSpec.describe WeeklyBusinessHour, type: :model do
  describe "associations" do
    it { should belong_to(:team_business_setting) }
  end

  describe "validations" do
    subject { build(:weekly_business_hour) }

    it { should validate_presence_of(:wday) }
    it { should validate_presence_of(:open) }
    it { should validate_presence_of(:close) }

    it "is invalid if close is before or equal to open" do
      weekly_hour = build(:weekly_business_hour, open: "10:00", close: "09:59")
      weekly_hour.valid?
      expect(weekly_hour.errors[:close]).to include("はオープンより後の時間にしてください")

      same_time = build(:weekly_business_hour, open: "10:00", close: "10:00")
      same_time.valid?
      expect(same_time.errors[:close]).to include("はオープンより後の時間にしてください")
    end
  end

  describe "enums" do
    it "defines correct wday enum mapping" do
      expect(described_class.wdays).to eq(
        { "sun" => 0, "mon" => 1, "tue" => 2, "wed" => 3, "thu" => 4, "fri" => 5, "sat" => 6 }
      )
    end
  end
end

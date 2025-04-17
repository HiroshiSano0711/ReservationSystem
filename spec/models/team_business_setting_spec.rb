require 'rails_helper'

RSpec.describe TeamBusinessSetting, type: :model do
  let(:team) { create(:team) }

  let(:valid_day_setting) do
    {
      "working_day" => "1",
      "open" => "09:00",
      "close" => "18:00"
    }
  end

  shared_examples 'invalid when' do |day, message, mutate_proc|
    it "#{day} is invalid: #{message}" do
      settings = TeamBusinessSetting::DAYS_OF_WEEK.index_with { valid_day_setting.deep_dup }
      mutate_proc.call(settings)
      team_business_setting = described_class.new(team: team, business_hours_for_day_of_week: settings)
      expect(team_business_setting).to be_invalid
      expect(team_business_setting.errors[day].join).to include(message)
    end
  end

  describe 'validations for each day' do
    TeamBusinessSetting::DAYS_OF_WEEK.each do |day|
      include_examples 'invalid when', day, 'はハッシュを入力してください', ->(setting) {
        setting[day] = "not-a-hash"
      }

      include_examples 'invalid when', day, 'はworking_day、open、closeのキーが必要です', ->(setting) {
        setting[day].delete("working_day")
      }

      include_examples 'invalid when', day, "に不正なキーが含まれています: unexpected", ->(setting) {
        setting[day]["unexpected"] = "oops"
      }

      include_examples 'invalid when', day, 'のworking_dayは1か0を入力してください', ->(setting) {
        setting[day]["working_day"] = "2"
      }

      include_examples 'invalid when', day, 'のopenはHH:MM形式で入力してください', ->(setting) {
        setting[day]["open"] = "25:00"
      }

      include_examples 'invalid when', day, 'のcloseはHH:MM形式で入力してください', ->(setting) {
        setting[day]["close"] = "25:00"
      }

      include_examples 'invalid when', day, 'のopenはcloseより前の時間を入力してください', ->(setting) {
        setting[day]["open"] = "18:00"
        setting[day]["close"] = "09:00"
      }
    end
  end
end

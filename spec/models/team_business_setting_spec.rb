require 'rails_helper'

RSpec.describe TeamBusinessSetting, type: :model do
  describe 'associations' do
    it { should belong_to(:team) }
  end

  describe 'store_accessor' do
    it 'has business hours for each day of the week' do
      team_business_setting = build(:team_business_setting, sun: { "working_day" => "1", "open" => "09:00", "close" => "17:00" })
      expect(team_business_setting.sun).to eq({"working_day" => "1", "open" => "09:00", "close" => "17:00"})
    end
  end

  describe '#working_day?' do
    it 'returns true for a working day' do
      team_business_setting = build(:team_business_setting, sun: { "working_day" => "1", "open" => "09:00", "close" => "17:00" })
      expect(team_business_setting.working_day?(Date.new(2025, 4, 20))).to be true # Sunday
    end

    it 'returns false for a non-working day' do
      team_business_setting = build(:team_business_setting, sun: { "working_day" => "0", "open" => "09:00", "close" => "17:00" })
      expect(team_business_setting.working_day?(Date.new(2025, 4, 20))).to be false # Sunday, but non-working day
    end
  end

  describe '#opening_hours' do
    it 'returns correct opening and closing hours' do
      team_business_setting = build(:team_business_setting, sun: { "working_day" => "1", "open" => "09:00", "close" => "17:00" })
      date = Date.new(2025, 4, 20) # Sunday
      opening_hours = team_business_setting.opening_hours(date)

      expect(opening_hours[:open].strftime("%H:%M")).to eq("09:00")
      expect(opening_hours[:close].strftime("%H:%M")).to eq("17:00")
    end

    it 'returns correct opening and closing hours for another day' do
      team_business_setting = build(:team_business_setting, mon: { "working_day" => "1", "open" => "08:00", "close" => "18:00" })
      date = Date.new(2025, 4, 21) # Monday
      opening_hours = team_business_setting.opening_hours(date)

      expect(opening_hours[:open].strftime("%H:%M")).to eq("08:00")
      expect(opening_hours[:close].strftime("%H:%M")).to eq("18:00")
    end
  end
end

require 'rails_helper'

RSpec.describe TeamBusinessSettingForm, type: :model do
  let(:team_business_setting) { create(:team_business_setting, :with_weekly_business_hours) }
  let(:form) { TeamBusinessSettingForm.new(team_business_setting: team_business_setting) }

  describe '#model_class_for' do
    it 'returns TeamBusinessSetting for team business setting attributes' do
      expect(form.model_class_for(:max_reservation_month)).to eq(TeamBusinessSetting)
    end

    it 'returns WeeklyBusinessHour for weekly business hour attributes' do
      expect(form.model_class_for(:open)).to eq(WeeklyBusinessHour)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(form).to be_valid
    end

    it 'is invalid if max_reservation_month is blank' do
      form.max_reservation_month = nil
      expect(form).to be_invalid
      expect(form.errors[:max_reservation_month]).to include("を入力してください")
    end

    it 'is invalid if max_reservation_month is not greater than 0' do
      form.max_reservation_month = 0
      expect(form).to be_invalid
      expect(form.errors[:max_reservation_month]).to include("は0より大きい値にしてください")
    end

    it 'is invalid if reservation_start_delay_days is blank' do
      form.reservation_start_delay_days = nil
      expect(form).to be_invalid
      expect(form.errors[:reservation_start_delay_days]).to include("を入力してください")
    end

    it 'is invalid if reservation_start_delay_days is not greater than equal to 0' do
      form.reservation_start_delay_days = -1
      expect(form).to be_invalid
      expect(form.errors[:reservation_start_delay_days]).to include("は0以上の値にしてください")
    end

    it 'is invalid if cancellation_deadline_hours_before is blank' do
      form.cancellation_deadline_hours_before = nil
      expect(form).to be_invalid
      expect(form.errors[:cancellation_deadline_hours_before]).to include("を入力してください")
    end

    it 'is invalid if cancellation_deadline_hours_before is not greater than equal to 0' do
      form.cancellation_deadline_hours_before = -1
      expect(form).to be_invalid
      expect(form.errors[:cancellation_deadline_hours_before]).to include("は0以上の値にしてください")
    end
  end
end

require 'rails_helper'

RSpec.describe TeamBusinessSettingForm, type: :model do
  let(:team_business_setting) { create(:team_business_setting, :with_weekly_business_hours) }
  let(:form) { TeamBusinessSettingForm.new(team_business_setting) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(form).to be_valid
    end

    it 'is invalid without required attributes' do
      form.max_reservation_month = nil
      expect(form).to be_invalid
    end
  end

  describe '#save' do
    context 'when valid data is provided' do
      let(:params) do
        {
          max_reservation_month: 6,
          reservation_start_delay_days: 3,
          cancellation_deadline_hours_before: 24,
          weekly_business_hours: {
            "0" => { "wday" => "sun", "working_day" => "1", "open" => "10:00", "close" => "20:00" },
          }
        }
      end

      it 'saves the team business setting' do
        expect { form.save(params) }.to change { team_business_setting.reload.max_reservation_month }.from(3).to(6)
      end

      it 'saves weekly business hours' do
        form.save(params)

        team_business_setting.reload
        weekly_business_hour = team_business_setting.weekly_business_hours.find { |wbh| wbh.wday === "sun" }
        expect(weekly_business_hour.open.strftime("%H:%M")).to eq("10:00")
        expect(weekly_business_hour.close.strftime("%H:%M")).to eq("20:00")
      end
    end

    context 'when invalid data is provided' do
      let(:params) { { max_reservation_month: nil } }

      it 'does not save the team business setting' do
        expect(form.save(params)).to be_falsey
      end
    end
  end

  describe '#model_class_for' do
    it 'returns TeamBusinessSetting for team business setting attributes' do
      expect(form.model_class_for(:max_reservation_month)).to eq(TeamBusinessSetting)
    end

    it 'returns WeeklyBusinessHour for weekly business hour attributes' do
      expect(form.model_class_for(:open)).to eq(WeeklyBusinessHour)
    end
  end
end

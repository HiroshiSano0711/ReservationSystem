require 'rails_helper'

RSpec.describe TeamBusinessSettingForm, type: :model do
  let(:team_business_setting) { create(:team_business_setting, :with_weekly_business_hours) }
  let(:form) { TeamBusinessSettingForm.new(team_business_setting) }

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

  describe '#save' do
    context 'when valid data is provided' do
      let(:params) do
        {
          max_reservation_month: 6,
          reservation_start_delay_days: 3,
          cancellation_deadline_hours_before: 24,
          weekly_business_hours_params: {
            "0" => { "wday" => "sun", "working_day" => "1", "open" => "10:00", "close" => "20:00" },
          }
        }
      end

      it 'saves the team business setting' do
        form.assign_attributes(params)

        expect { form.save }.to change { team_business_setting.reload.max_reservation_month }.from(3).to(6)
      end

      it 'saves weekly business hours' do
        form.assign_attributes(params)

        expect(form.save).to be_truthy

        team_business_setting.reload
        weekly_business_hour = team_business_setting.weekly_business_hours.find { |wbh| wbh.wday === "sun" }
        expect(weekly_business_hour.open.strftime("%H:%M")).to eq("10:00")
        expect(weekly_business_hour.close.strftime("%H:%M")).to eq("20:00")
      end
    end

    context 'when invalid data is provided' do
      let(:params) { { max_reservation_month: -1 } }

      it 'does not save the team business setting' do
        form.assign_attributes(params)
 
        expect(form.save).to be_falsey
        expect(form.errors[:max_reservation_month]).to be_present
      end
    end
  end
end

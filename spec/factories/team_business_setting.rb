FactoryBot.define do
  factory :team_business_setting do
    association :team

    max_reservation_month { 3 }
    reservation_start_delay_days { 0 }
    cancellation_deadline_hours_before { 24 }

    trait :with_weekly_business_hours do
      after(:create) do |team_business_setting|
        create(:weekly_business_hour, team_business_setting: team_business_setting, wday: :sun)
        create(:weekly_business_hour, team_business_setting: team_business_setting, wday: :mon)
        create(:weekly_business_hour, team_business_setting: team_business_setting, wday: :tue)
        create(:weekly_business_hour, team_business_setting: team_business_setting, wday: :wed)
        create(:weekly_business_hour, team_business_setting: team_business_setting, wday: :thu)
        create(:weekly_business_hour, team_business_setting: team_business_setting, wday: :fri)
        create(:weekly_business_hour, team_business_setting: team_business_setting, wday: :sat)
      end
    end
  end
end

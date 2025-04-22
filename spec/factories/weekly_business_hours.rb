FactoryBot.define do
  factory :weekly_business_hour do
    association :team_business_setting

    wday { 'mon' }
    open { "09:00" }
    close { "18:00" }
    working_day { true }
  end
end

FactoryBot.define do
  factory :weekly_business_hour do
    team_business_setting
    wday { 1 } # 月曜
    open { "09:00" }
    close { "18:00" }
    working_day { true }
  end
end

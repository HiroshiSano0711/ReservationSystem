FactoryBot.define do
  factory :staff_profile do
    association :staff

    nick_name { "Test Staff" }
    working_status { "active" }
  end
end

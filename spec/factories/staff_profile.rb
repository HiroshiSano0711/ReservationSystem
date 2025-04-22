FactoryBot.define do
  factory :staff_profile do
    staff
    nick_name { "Test Staff" }
    working_status { "active" }
  end
end

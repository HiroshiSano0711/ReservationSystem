FactoryBot.define do
  factory :customer_profile do
    association :customer

    name { "Test Staff" }
    phone_number { "09012345678" }
  end
end

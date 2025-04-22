FactoryBot.define do
  factory :service_menu do
    association :team
    sequence(:menu_name) { |n| "Team Menu #{n}" }
    duration { 30 }
    price { 4000 }
    required_staff_count { 1 }
    available_from { FIXED_TIME.call }
    available_until { nil }
  end
end

FactoryBot.define do
  factory :service_menu do
    association :team
    sequence(:name) { |n| "Team Menu #{n}" }
    duration { 30 }
    price { 4000 }
    required_staff_count { 1 }
    available_from { Time.zone.local(2025, 1, 1, 9, 0, 0) }
    available_until { nil }
  end
end

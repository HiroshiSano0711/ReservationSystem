FactoryBot.define do
  factory :reservation do
    association :team
    customer_id { nil }

    sequence(:public_id) { |n| "public-id-#{n}" }
    start_time { Time.zone.local(2025, 1, 1, 9, 0, 0) }
    end_time { Time.zone.local(2025, 1, 1, 9, 30, 0) }

    customer_name { "山田太郎" }
    customer_phone_number { "09012345678" }
    total_price { 4000 }
    total_duration { 30 }
    required_staff_count { 1 }
    menu_summary { "カラー, カット" }
    assigned_staff_name { "おまかせ" }
    status { "finalize" }
  end
end

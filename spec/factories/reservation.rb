FactoryBot.define do
  factory :reservation do
    team
    customer_id { nil }
    sequence(:public_id) { |n| "public-id-#{n}" }
    date { FIXED_TIME.call.to_date }
    start_time { "09:00" }
    end_time { "09:30" }
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

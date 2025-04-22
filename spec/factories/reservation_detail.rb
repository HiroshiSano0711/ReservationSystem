FactoryBot.define do
  factory :reservation_detail do
    association :reservation
    association :service_menu

    staff { nil }
    menu_name { "カット, カラー" }
    price { 3000 }
    duration { 30 }
    required_staff_count { 1 }
  end
end

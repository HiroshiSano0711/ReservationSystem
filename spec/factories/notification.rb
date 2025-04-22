FactoryBot.define do
  factory :notification do
    association :team
    sender_id { nil }
    receiver_id { nil }

    notification_type { :reservation_created }
    status { :unread }
    message { "~さんから予約が入りました" }
    action_url { "http://test.localhost:3000/" }
  end
end

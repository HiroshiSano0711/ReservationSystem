FactoryBot.define do
  factory :notification do
    association :team
    association :receiver, factory: :staff
    association :reservation

    notification_type { :reservation_created }
    is_read { false }
    action_url { "http://test.localhost:3000/" }
  end
end

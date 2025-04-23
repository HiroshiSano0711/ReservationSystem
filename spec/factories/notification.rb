FactoryBot.define do
  factory :notification do
    transient do
      team { create(:team) }
    end

    association :team, factory: :team, strategy: :build
    association :receiver, factory: :staff, strategy: :build
    association :reservation, factory: :reservation, strategy: :build

    notification_type { :reservation_created }
    is_read { false }
    action_url { "http://test.localhost:3000/" }

    after(:build) do |notification, evaluator|
      notification.team = evaluator.team
      notification.receiver.team = evaluator.team
      notification.reservation.team = evaluator.team
    end
  end
end

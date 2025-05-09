FactoryBot.define do
  factory :customer do
    sequence(:email) { |n| "test-#{n}@example.com" }
    password { "password" }
    invitation_token { Devise.friendly_token }
    invitation_sent_at { Time.zone.now }
    invitation_accepted_at { nil }
  end
end

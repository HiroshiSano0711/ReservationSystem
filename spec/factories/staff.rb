FactoryBot.define do
  factory :staff do
    team
    sequence(:email) { |n| "test-#{n}@example.com" }
    password { 'password' }
    invitation_token { Devise.friendly_token(20) } # default length 20
    invitation_sent_at { Time.zone.now }
    invitation_accepted_at { nil }
  end
end

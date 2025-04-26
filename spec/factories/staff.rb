FactoryBot.define do
  factory :staff do
    association :team

    sequence(:email) { |n| "test-#{n}@example.com" }
    password { "password" }
    invitation_token { Devise.friendly_token }
    invitation_sent_at { FIXED_TIME.call }
    invitation_accepted_at { nil }

    role { :general }

    trait :admin do
      role { :admin_staff }
    end

    trait :with_profile do
      after(:create) do |staff|
        create(:staff_profile, staff: staff)
      end
    end
  end
end

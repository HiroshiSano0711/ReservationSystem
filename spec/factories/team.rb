FactoryBot.define do
  factory :team do
    name { "Test Team" }
    sequence(:permalink) { |n| "test-team-#{n}" }
  end
end

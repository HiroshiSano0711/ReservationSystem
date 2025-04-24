FactoryBot.define do
  factory :team do
    sequence(:name) { |n| "Test Team #{n}" }
    sequence(:permalink) { |n| "test-team-#{n}" }

    after(:create) do |team|
      create(:team_business_setting, team: team)
    end
  end
end

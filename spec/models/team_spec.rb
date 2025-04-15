require 'rails_helper'

RSpec.describe Team, type: :model do
  it "is valid with valid attributes" do
    team = Team.new(name: "Test Team", permalink: 'test-sample')
    expect(team).to be_valid
  end

  it "is valid with valid permalinks" do
    invalid_formats = %w(a1-12 aa-bb-cc aaaaa-bbbbb-ccccc-ddddd-eeeee-ff)
    team = Team.new(name: "Test Team", permalink: 'test-sample')
    expect(team).to be_valid
  end

  it "is not valid without a name" do
    team = Team.new(name: nil)
    expect(team).not_to be_valid
  end

  it "is not valid without a permalink" do
    team = Team.new(name: "Test Team", permalink: nil)
    expect(team).not_to be_valid
  end

  it "is not valid with same permalink" do
    Team.create(name: "Test Team", permalink: 'same-permalink')
    team = Team.new(name: "Test Team2", permalink: 'same-permalink')
    expect(team).not_to be_valid
  end

  it "is not valid with wrong permalink format" do
    invalid_formats = %w(nohypen 123-456 1-2 aaaaa-bbbbb-ccccc-ddddd-eeeee-fff)
    invalid_formats.each do |invalid_format|
      team = Team.new(name: "Test Team", permalink: invalid_format)
      expect(team).not_to be_valid
    end
  end
end

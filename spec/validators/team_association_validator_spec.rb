require "rails_helper"

RSpec.describe TeamAssociationValidator, type: :validator do
  describe "#validate!" do
    it "is not raise error if all assosiation are same team" do
      team = create(:team)
      service_menu_1 = create(:service_menu, team: team)
      service_menu_2 = create(:service_menu, team: team)
      staff = create(:staff, team: team)

      expect {
        TeamAssociationValidator.new(
          team: team,
          objects: [service_menu_1, service_menu_2, staff]
        ).validate!
      }.not_to raise_error
    end

    it "raise error if service menu are not same team" do
      team = create(:team, name: 'Test Team')
      team_2 = create(:team, name: 'Test Team 2')
      service_menu_1 = create(:service_menu, team: team)
      service_menu_2 = create(:service_menu, team: team_2)
      staff = create(:staff, team: team)

      expect {
        TeamAssociationValidator.new(
          team: team,
          objects: [service_menu_1, service_menu_2, staff]
        ).validate!
      }.to raise_error(TeamAssociationValidator::InvalidTeamAssociationError, "ServiceMenuの所属チームが一致していません")
    end

    it "raise error if staff are not same team" do
      team = create(:team, name: 'Test Team')
      team_2 = create(:team, name: 'Test Team 2')
      service_menu_1 = create(:service_menu, team: team)
      service_menu_2 = create(:service_menu, team: team)
      staff = create(:staff, team: team_2)

      expect {
        TeamAssociationValidator.new(
          team: team,
          objects: [service_menu_1, service_menu_2, staff]
        ).validate!
      }.to raise_error(TeamAssociationValidator::InvalidTeamAssociationError, "Staffの所属チームが一致していません")
    end
  end
end

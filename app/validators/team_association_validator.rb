class TeamAssociationValidator
  class InvalidTeamAssociationError < StandardError; end

  def initialize(team:, objects:)
    @team = team
    @objects = objects.flatten.compact
  end

  def validate!
    @objects.each do |obj|
      object_team = obj.try(:team)
      unless object_team == @team
        raise InvalidTeamAssociationError, "#{obj.class}の所属チームが一致していません"
      end
    end
  end
end

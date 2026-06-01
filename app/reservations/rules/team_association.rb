module Reservations
  module Rules
    class TeamAssociation
      def initialize(team:, objects:)
        @team = team
        @objects = objects.flatten.compact
      end

      def validate!
        @objects.each { |obj| raise if @team != obj.team }
      end
    end
  end
end

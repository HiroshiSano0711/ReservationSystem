module Queries
  module Reservations
    class ByDateRange
      def initialize(team)
        @team = team
      end

      def call(start_date, end_date)
        @team.reservations
             .select(:id, :start_time, :end_time, :required_staff_count)
             .where(start_time: start_date.beginning_of_day..end_date.end_of_day)
             .group_by { |r| r.start_time.to_date }
      end
    end
  end
end

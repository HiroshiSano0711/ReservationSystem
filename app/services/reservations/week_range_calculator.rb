module Reservations
  class WeekRangeCalculator
    def initialize(start_date_str:, max_reservation_month:)
      @start_date = parse_date(start_date_str) || Date.today
      @max_date = Date.today + max_reservation_month.months
      @today = Date.today
    end

    def call
      @start_date = [@start_date, @today].max
      @start_date = [@start_date, @max_date].min
      @end_date = [@start_date + 1.week, @max_date].min
      [@start_date, @end_date]
    end

    def previous_week_available?
      @start_date > Date.today
    end

    def next_week_available?
      @end_date < @max_date
    end

    private

    def parse_date(date_str)
      Date.parse(date_str) rescue nil
    end
  end
end

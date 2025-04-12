module Reservations
  class WeekRangeCalculator
    def initialize(start_date_str:, max_reservation_month:)
      @start_date = parse_date(start_date_str) || Time.zone.today
      @max_date = Time.zone.today + max_reservation_month.months
      @today = Time.zone.today
    end

    def call
      @start_date = [@start_date, @today].max
      @start_date = [@start_date, @max_date].min
      @end_date = [@start_date + 1.week, @max_date].min
      [@start_date, @end_date]
    end

    def previous_week_available?
      @start_date > Time.zone.today
    end

    def next_week_available?
      @end_date < @max_date
    end

    private

    def parse_date(date_str)
      Time.zone.parse(date_str).to_date rescue nil
    end
  end
end

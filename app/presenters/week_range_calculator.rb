module Presenters
  class WeekRangeCalculator
    WeekRange = Data.define(:start_date, :end_date, :previous_week_available?, :next_week_available?)

    def initialize(start_date_str:, max_reservation_month:)
      @start_date = parse_date(start_date_str) || Time.zone.today
      @max_date = Time.zone.today + max_reservation_month.months
      @today = Time.zone.today
    end

    def calc
      @start_date = [ @start_date, @today ].max
      @start_date = [ @start_date, @max_date ].min
      @end_date = [ @start_date + 6.day, @max_date ].min

      WeekRange.new(
        start_date: @start_date,
        end_date: @end_date,
        previous_week_available?: previous_week_available?,
        next_week_available?: next_week_available?
      )
    end

    def previous_week_available?
      @start_date > @today
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

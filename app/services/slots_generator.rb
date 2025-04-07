class SlotsGenerator
  INTERVAL = 15.minutes

  def initialize(team:, menus:, start_date:, end_date:, selected_staff:)
    @team = team
    @menus = menus
    @start_date = start_date
    @end_date = end_date
    @selected_staff = selected_staff
    @business_setting = team.team_business_setting
    @total_duration = @menus.sum(&:duration).minutes
    @staff_count = @team.staffs.count
  end

  def call
    preload_reservations

    (@start_date..@end_date).map do |date|
      generate_slots_for_date(date)
    end
  end

  private

  def preload_reservations
    @reservations_by_date = @team.reservations
                                 .where(date: @start_date..@end_date)
                                 .select(:id, :date, :start_time, :end_time)
                                 .group_by(&:date)
  end

  def generate_slots_for_date(date)
    business_hours = @business_setting.send(date.strftime('%a').downcase.to_sym)
    return { date: date, slots: [] } if business_hours['working_day'] == '0'

    open_time = Time.zone.parse("#{date} #{business_hours['open']}")
    close_time = Time.zone.parse("#{date} #{business_hours['close']}")

    slots = []
    start_time = open_time
    end_time = start_time + @total_duration

    day_reservations = @reservations_by_date[date] || []

    while end_time <= close_time

      overlap_count = day_reservations.count do |r|
        time_overlap?(
          Time.zone.parse("#{date} #{r.start_time}"),
          Time.zone.parse("#{date} #{r.end_time}"),
          start_time,
          end_time
        )
      end

      if overlap_count < @staff_count
        slots << { start: start_time, end: end_time }
      end

      start_time += INTERVAL
      end_time += INTERVAL
    end

    { date: date, slots: slots }
  end

  def time_overlap?(start1, end1, start2, end2)
    start1 < end2 && start2 < end1
  end
end

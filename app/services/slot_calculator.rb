class SlotCalculator
  INTERVAL = 10.minutes

  def initialize(business_setting, staff_count, duration)
    @business_setting = business_setting
    @staff_count = staff_count
    @duration = duration
  end

  def generate_slots_for_date(date, reservations_by_date)
    slots = []
    reservations_for_day = reservations_by_date[date] || []
    opening_hours = @business_setting.opening_hours(date)

    (opening_hours[:open].to_i..(opening_hours[:close] - @duration).to_i).step(INTERVAL.to_i).each do |start_time_int|
      start_time = Time.at(start_time_int)
      end_time = start_time + @duration

      if available_slot?(start_time, end_time, reservations_for_day)
        slots << { start: start_time, end: end_time }
      end
    end

    slots
  end

  private

  def available_slot?(start_time, end_time, reservations)
    return true if reservations.blank?

    overlap_count = reservations.count do |r|
      time_overlap?(
        Time.zone.parse("#{r.date} #{r.start_time}"),
        Time.zone.parse("#{r.date} #{r.end_time}"),
        start_time,
        end_time
      )
    end

    overlap_count < @staff_count
  end

  def time_overlap?(start1, end1, start2, end2)
    start1 < end2 && start2 < end1
  end
end

class SlotCalculator
  INTERVAL = 10.minutes

  def initialize(team:, business_setting:, service_menus:, selected_staff:)
    @team = team
    @business_setting = business_setting
    @service_menus = service_menus
    @selected_staff = selected_staff
    @duration = service_menus.sum(&:duration).minutes
    @required_staff_count = service_menus.map(&:required_staff_count).max
    @available_staff_list = selected_staff.present? ? [selected_staff] : preload_available_staff
  end

  def generate_slots_for_date(date, reservations_by_date)
    slots = []
    reservations_for_day = reservations_by_date[date] || []
    opening_hours = @business_setting.opening_hours(date)

    (opening_hours[:open].to_i..(opening_hours[:close] - @duration).to_i).step(INTERVAL.seconds).each do |start_time_int|
      start_time = Time.at(start_time_int)
      end_time = start_time + @duration

      if available_slot?(start_time, end_time, reservations_for_day)
        slots << { start: start_time, end: end_time }
      end
    end

    slots
  end

  private

  def preload_available_staff
    @team.staffs
         .joins(:service_menus)
         .where(service_menus: { id: @service_menus.map(&:id) })
         .group('staffs.id')
         .having('COUNT(service_menus.id) = ?', @service_menus.size)
         .distinct
  end

  def available_slot?(start_time, end_time, reservations)
    return true if reservations.blank?

    relevant_reservations = reservations.select do |r|
      (r.staffs.map(&:id) & @available_staff_list.map(&:id)).any?
    end

    overlap_count = relevant_reservations.count do |r|
      time_overlap?(
        Time.zone.parse("#{r.date} #{r.start_time}"),
        Time.zone.parse("#{r.date} #{r.end_time}"),
        start_time,
        end_time
      )
    end

    overlap_count < @available_staff_list.size
  end

  def time_overlap?(reservation_start, reservation_end, slot_start, slot_end)
    reservation_start < slot_end && slot_start < reservation_end
  end
end

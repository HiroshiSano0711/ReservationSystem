class SlotCalculator
  INTERVAL = 10.minutes

  def initialize(team:, business_setting:, service_menus:, selected_staff:)
    @team = team
    @business_setting = business_setting
    @service_menus = service_menus
    @selected_staff = selected_staff
    @duration = service_menus.sum(&:duration).minutes
    @required_staff_count = service_menus.map(&:required_staff_count).max
    @available_staff_list = selected_staff.present? ? [ selected_staff ] : preload_available_staff
  end

  def generate_slots_for_date(date, reservations_by_date)
    slots = []
    reservations_for_day = reservations_by_date[date] || []
    opening_hours = @business_setting.opening_hours(date)
    earliest_date = Time.zone.today + @business_setting.reservation_start_delay_days

    return [] if date < earliest_date

    current_time = opening_hours[:open]

    while current_time + @duration <= opening_hours[:close]
      if date == Time.zone.today && current_time < Time.zone.now
        current_time += INTERVAL
        next
      end

      end_time = current_time + @duration

      if available_slot?(current_time, end_time, reservations_for_day)
        slots << { start: current_time, end: end_time }
      end

      current_time += INTERVAL
    end

    slots
  end

  private

  def preload_available_staff
    @team.staffs
         .joins(:service_menus)
         .where(service_menus: { id: @service_menus.map(&:id) })
         .group("staffs.id")
         .having("COUNT(service_menus.id) = ?", @service_menus.size)
         .distinct
  end

  def available_slot?(start_time, end_time, reservations)
    return true if @available_staff_list.blank?

    overlapping_staff_count = reservations.sum do |r|
      next 0 unless time_overlap?(
        Time.zone.parse("#{r.date} #{r.start_time}"),
        Time.zone.parse("#{r.date} #{r.end_time}"),
        start_time,
        end_time
      )

      r.required_staff_count || 1
    end

    overlapping_staff_count + @required_staff_count <= @available_staff_list.size
  end

  def time_overlap?(reservation_start, reservation_end, slot_start, slot_end)
    reservation_start < slot_end && reservation_end > slot_start
  end
end

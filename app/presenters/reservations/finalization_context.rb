module Reservations
  class FinalizationContext
    attr_reader :team, :service_menus, :selected_staff, :start_time

    def initialize(team:, session:)
      @team = team
      @service_menus = team.service_menus.find(session.selected_service_menu_ids)
      @selected_staff = Staff.find_by(id: session.selected_staff_id)
      @start_time = Time.zone.parse(session.selected_slot)
    end

    def staff_name
      @selected_staff.present? ? @selected_staff.staff_profile.nick_name : "おまかせ"
    end

    def service_menu_list
      @service_menus.map(&:menu_name).join(", ")
    end

    def total_price
      @service_menus.sum(&:price)
    end

    def total_duration
      @service_menus.sum(&:duration)
    end

    def reservation_time_str
      "#{@start_time.strftime('%Y年%m月%d日') } #{@start_time.strftime("%H:%M")}~#{end_time.strftime("%H:%M")}"
    end

    def end_time
      @start_time + total_duration.minutes
    end
  end
end

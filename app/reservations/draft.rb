module Reservations
  class Draft
    attr_reader :team,
                :service_menus,
                :staff,
                :start_time,
                :end_time,
                :total_duration,
                :total_price,
                :required_staff_count,
                :menu_summary,
                :assigned_staff_name

    def self.build_from(team:, params:)
      raise ArgumentError if team.blank?

      service_menus = team.service_menus.find(params[:service_menu_ids])
      raise ArgumentError if service_menus.blank?
      raise ArgumentError if params[:start_time_str].blank?
      raise ArgumentError unless params[:start_time_str].match(Reservations::TimeResolver::VALID_TIME_FORMAT)

      start_time = Reservations::TimeResolver.parse_with_user_time_zone(time_str: params[:start_time_str])
      staff = team.staffs.find_by(id: params[:staff_id])

      new(
        team: team,
        service_menus: service_menus,
        staff: staff,
        start_time: start_time,
        end_time: start_time + service_menus.sum(&:duration).minutes
      )
    end

    def initialize(team:, service_menus:, staff:, start_time:, end_time:)
      @team = team
      @service_menus = service_menus
      @staff = staff
      @start_time = start_time
      @end_time = end_time
      @total_duration = service_menus.sum(&:duration)
      @total_price = service_menus.sum(&:price)
      @required_staff_count = service_menus.map(&:required_staff_count).max
      @menu_summary = service_menus.map(&:name).join(",")
      @assigned_staff_name = staff&.profile&.nick_name || "おまかせ"
    end
  end
end

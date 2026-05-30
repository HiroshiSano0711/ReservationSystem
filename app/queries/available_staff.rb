module Queries
  class AvailableStaff
    def initialize(team)
      @team = team
    end

    def by_service_menus(service_menus)
      @team.staffs
          .joins(:service_menus)
          .where(service_menus: { id: service_menus.map(&:id) })
          .group("staffs.id")
          .having("COUNT(service_menus.id) = ?", service_menus.size)
          .distinct
    end
  end
end

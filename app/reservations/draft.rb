module Reservations
  class Draft
    attr_reader :service_menus,
                :selected_staff,
                :start_time,
                :end_time
    attr_accessor :customer_name,
                  :customer_phone_number

    def initialize(service_menus:, selected_staff:, start_time:)
      @service_menus = service_menus
      @selected_staff = selected_staff
      @start_time = start_time
      @end_time = start_time + service_menus.sum(&:duration).minutes
    end

    def add_profile(customer_name:, customer_phone_number:)
      self.customer_name = customer_name
      self.customer_phone_number = customer_phone_number
    end
  end
end

module Admin
  module StaffProfileHelper
    def accepts_direct_booking_options
      [
        ['受け付ける', 1],
        ['受け付けない', 0]
      ]
    end

    def convert_boolean_to_string(accepts_direct_booking)
      accepts_direct_booking ? '1' : '0'
    end
  end
end

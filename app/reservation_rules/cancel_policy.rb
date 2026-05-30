module ReservationRules
  class CancelPolicy
    def initialize(reservation)
      @reservation = reservation
    end

    def valid?
      border_line_time = Time.zone.now + @reservation.team.team_business_setting.cancellation_deadline_hours_before.hours
      @reservation.start_time > border_line_time
    end
  end
end

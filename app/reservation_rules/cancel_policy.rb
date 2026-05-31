module ReservationRules
  class CancelPolicy
    def initialize(reservation)
      @reservation = reservation
    end

    def validate
      result = Result.new
      result.add_error(validate_cancellable)
      result
    end

    private

    def validate_cancellable
      border_line_time = Time.zone.now + @reservation.team.team_business_setting.cancellation_deadline_hours_before.hours
      return if @reservation.start_time > border_line_time

      "キャンセル可能期限が過ぎているためキャンセルできません。"
    end
  end
end

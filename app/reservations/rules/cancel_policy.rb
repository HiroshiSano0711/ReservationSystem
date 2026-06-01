module Reservations
  module Rules
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
        border_line_time = @reservation.start_time - @reservation.team.team_business_setting.cancellation_deadline_hours_before.hours
        return if Time.zone.now <= border_line_time

        "キャンセル可能期限が過ぎているためキャンセルできません。"
      end
    end
  end
end

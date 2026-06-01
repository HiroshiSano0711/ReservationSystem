module Services
  module Reservations
    class Cancel
      # @actorの値に何を渡すかはReservationStatusLogのenum :changed_byを確認
      def initialize(reservation:, actor:)
        @reservation = reservation
        @actor = actor
      end

      def call
        result = ::ReservationRules::CancelPolicy.new(@reservation).validate
        return Result.new(success: false, message: result.messages) if result.invalid?

        ActiveRecord::Base.transaction do
          @reservation.update!(status: :canceled)
          ReservationStatusLog.create!(
            reservation: @reservation,
            from_status: :finalized,
            to_status: :canceled,
            changed_by: @actor
          )
        end

        Result.new(success: true, resource: @reservation)
      rescue ActiveRecord::RecordInvalid, ActiveRecord::NotNullViolation => e
        ::Rails.logger.error("システムエラー: #{e.message}")
        Result.new(success: false, message: "システムエラーが発生しました。お手数ですが管理者へお問い合わせください。")
      end
    end
  end
end

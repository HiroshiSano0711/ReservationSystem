module Services
  module Reservations
    class Cancel
      def initialize(reservation:, customer:)
        @reservation = reservation
        @customer = customer
      end

      def call
        return failure("キャンセル期限を過ぎています") unless cancelable?

        @reservation.update!(status: :canceled)
        success(@reservation)
      rescue => e
        failure("システムエラーが発生しました: #{e.message}")
      end

      private

      def cancelable?
        ::ReservationRules::CancelPolicy.new(@reservation).valid?
      end

      def success(resource = nil)
        Result.new(success: true, resource: resource)
      end

      def failure(message)
        Result.new(success: false, message: message)
      end
    end
  end
end

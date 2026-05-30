module Services
  module Reservations
    class Cancel
      def initialize(reservation:, customer:)
        @reservation = reservation
        @customer = customer
      end

      def call
        return Result.new(success: false, message: "キャンセル期限を過ぎています") unless cancelable?

        @reservation.update!(status: :canceled)
        Result.new(success: true, resource: @reservation)
      end

      private

      def cancelable?
        ::ReservationRules::CancelPolicy.new(@reservation).valid?
      end
    end
  end
end

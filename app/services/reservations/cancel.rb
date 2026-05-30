module Services
  module Reservations
    class Cancel
      def initialize(reservation:, customer:)
        @reservation = reservation
        @customer = customer
      end

      def call(admin: false)
        # TODO: adminという引数渡して処理してるのは責務と関係ないので分離したい。
        return failure("不正な操作です") unless admin || owned_by_customer?
        return failure("キャンセル期限を過ぎています") unless admin || cancelable?

        @reservation.update!(status: :canceled)
        ReservationStatusLog.create!(
          reservation: @reservation,
          from_status: :finalized,
          to_status: :canceled,
          changed_by: admin ? :admin : :customer
        )
        success(@reservation)
      rescue => e
        failure("システムエラーが発生しました: #{e.message}")
      end

      private

      def owned_by_customer?
        @reservation.customer == @customer
      end

      def cancelable?
        @reservation.cancelable?
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

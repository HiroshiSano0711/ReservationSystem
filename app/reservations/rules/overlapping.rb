module Reservations
  module Rules
    class Overlapping
      def initialize(reservation)
        @reservation = reservation
      end

      def validate
        result = Result.new
        result.add_error(overlapping)
        result
      end

      private

      def overlapping
        return unless @reservation.customer_id.present?

        overlapping = Queries::Reservations::OverlappingForCustomer.new.call(@reservation)

        if overlapping
          "すでに予約している時間帯と重複しています"
        end
      end
    end
  end
end

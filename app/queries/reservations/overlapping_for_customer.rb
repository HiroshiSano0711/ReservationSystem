module Queries
  module Reservations
    class OverlappingForCustomer
      def call(reservation)
        ::Reservation
          .where(customer_id: reservation.customer_id)
          .where.not(id: reservation.id)
          .where("start_time < ? AND end_time > ?", reservation.end_time, reservation.start_time)
          .exists?
      end
    end
  end
end

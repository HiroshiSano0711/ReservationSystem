module ReservationRules
  class Overlapping
    def initialize(reservation)
      @reservation = reservation
    end

    def validate
      validate_overlapping_reservations
    end

    private

    def validate_overlapping_reservations
      return unless @reservation.customer_id.present?

      overlapping = Queries::Reservations::OverlappingForCustomer.new.call(@reservation)

      if overlapping
        @reservation.errors.add(:overlapp, "すでに予約している時間帯と重複しています")
      end
    end
  end
end

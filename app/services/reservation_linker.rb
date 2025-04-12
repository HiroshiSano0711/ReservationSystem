class ReservationLinker
  def initialize(customer:, public_id:)
    @customer = customer
    @public_id = public_id
  end

  def link_reservation
    reservation = Reservation.find_by(public_id: @public_id)
    return unless reservation

    reservation.update(customer: @customer)
  end
end

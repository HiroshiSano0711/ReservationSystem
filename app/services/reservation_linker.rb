class ReservationLinker
  def initialize(customer:, public_id:)
    @customer = customer
    @public_id = public_id
  end

  def link_reservation
    reservation = Reservation.find_by(public_id: @public_id)
    return if reservation.blank?

    begin
      reservation.update!(customer: @customer)
      @customer.create_customer_profile!(
        name: reservation.customer_name,
        phone_number: reservation.customer_phone_number
      )
    rescue StandardError => e
      Rails.logger.error("Reservation linking failed: #{e.message}")
    end
  end
end

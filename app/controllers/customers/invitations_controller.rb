# frozen_string_literal: true

class Customers::InvitationsController < Devise::InvitationsController
  def update
    super

    reservation_session = Reservations::SessionData.new(session)
    if reservation_session.public_id.present?
      ReservationLinker.new(customer: resource, public_id: reservation_session.public_id).link_reservation
      reservation_session.clear_public_id
    end
  end
end

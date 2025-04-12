# frozen_string_literal: true

class Customers::InvitationsController < Devise::InvitationsController
  def update
    super

    public_id = session[:public_id]
    if public_id.present?
      ReservationLinker.new(customer: resource, public_id: public_id).link_reservation
      session.delete(:public_id)
    end
  end
end

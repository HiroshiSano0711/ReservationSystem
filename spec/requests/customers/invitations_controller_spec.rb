require "rails_helper"

describe Customers::InvitationsController, type: :request do
  describe "PATCH /customers/invitation" do
    let(:customer) { Customer.invite!(email: 'test@example.com') }

    before { allow(Time.zone).to receive(:today).and_return(FIXED_TIME.call.to_date) }

    context "when invitation is accepted successfully" do
      it "accepts the invitation and redirects to the appropriate page" do
        reservation = create(:reservation, customer: nil)
        allow_any_instance_of(Reservations::SessionData).to receive(:public_id).and_return(reservation.public_id)

        patch customer_invitation_path, params: {
          customer: {
            invitation_token: customer.raw_invitation_token,
            password: 'password123',
            password_confirmation: 'password123'
          }
        }

        reservation.reload
        expect(reservation.customer.email).to eq('test@example.com')
        expect(response).to redirect_to(root_path)
      end
    end

    context "when the reservation linking fails" do
      it "does not fail the invitation process" do
        allow_any_instance_of(Reservation).to receive(:update!).and_raise(StandardError.new("Reservation linking failed"))
        reservation = create(:reservation, customer: nil)
        allow_any_instance_of(Reservations::SessionData).to receive(:public_id).and_return(reservation.public_id)

        patch customer_invitation_path, params: {
          customer: {
            invitation_token: customer.raw_invitation_token,
            password: 'password123',
            password_confirmation: 'password123'
          }
        }

        expect(response).to redirect_to(root_path)
      end
    end
  end
end

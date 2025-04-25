require "rails_helper"

RSpec.describe Mypage::ReservationsController, type: :request do
  let(:customer) { create(:customer) }
  let!(:reservation) { create(:reservation, customer: customer, public_id: "abc123", date: Date.tomorrow, start_time: "10:00") }

  before do
    sign_in customer
  end

  describe "GET /mypage/reservations" do
    it "renders reservation index" do
      get mypage_reservations_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /mypage/reservations/:public_id" do
    it "renders reservation details" do
      get mypage_reservation_path(public_id: reservation.public_id)

      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /mypage/reservations/:public_id/cancel" do
    context "when cancellation is successful" do
      it "cancels the reservation and redirects to index with a notice" do
        patch cancel_mypage_reservation_path(public_id: reservation.public_id)

        expect(response).to redirect_to(mypage_reservations_path)
        expect(flash[:notice]).to be_present
      end
    end

    context "when cancellation fails" do
      it "redirects to reservation page with alert" do
        allow_any_instance_of(Reservation).to receive(:cancelable?).and_return(false)

        patch cancel_mypage_reservation_path(public_id: reservation.public_id)

        expect(response).to redirect_to(mypage_reservation_path(public_id: reservation.public_id))
        expect(flash[:alert]).to be_present
      end
    end
  end
end

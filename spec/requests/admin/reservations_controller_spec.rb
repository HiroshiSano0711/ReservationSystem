require 'rails_helper'

RSpec.describe "Admin::ReservationsController", type: :request do
  include_context "admin access setup"

  before do
    sign_in admin, scope: :staff
    allow(Time.zone).to receive(:today).and_return(FIXED_TIME.call.to_date)
  end

  describe "GET /admin/reservations" do
    it "returns a successful response" do
      get admin_reservations_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /admin/reservations/:public_id" do
    it "returns a successful response" do
      reservation = create(:reservation, team: team)

      get admin_reservation_path(public_id: reservation.public_id)

      expect(response).to have_http_status(:success)
    end

    it "returns a 404 if reservation not found" do
      get admin_reservation_path(public_id: 'invalid_id')

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PATCH /admin/reservations/:public_id/cancel" do
    it "cancels the reservation and redirects to the reservation show page with a notice" do
      reservation = create(:reservation, team: team)

      patch cancel_admin_reservation_path(public_id: reservation.public_id)

      expect(response).to redirect_to(admin_reservation_path(public_id: reservation.public_id))
      expect(flash[:notice]).to be_present
    end

    it "cancels the reservation and redirects to the reservation show page with a notice" do
      cancel_service = instance_double(Reservations::CancelService)
      allow(Reservations::CancelService).to receive(:new).and_return(cancel_service)
      allow(cancel_service).to receive(:call).and_return(ServiceResult.new(success: false, message: "システムエラーが発生しました"))
      reservation = create(:reservation, team: team)

      patch cancel_admin_reservation_path(public_id: reservation.public_id)

      expect(response).to redirect_to(admin_reservation_path(public_id: reservation.public_id))
      expect(flash[:alert]).to be_present
    end
  end
end

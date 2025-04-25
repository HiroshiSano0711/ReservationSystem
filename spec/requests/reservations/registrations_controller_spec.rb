require "rails_helper"

RSpec.describe Reservations::RegistrationsController, type: :request do
  let(:team) { create(:team) }
  let(:customer) { create(:customer) }
  let(:reservation) { create(:reservation, team: team, customer: customer, customer_phone_number: "09012345678") }

  before { allow(Time.zone).to receive(:today).and_return(FIXED_TIME.call.to_date) }

  describe "GET /reservations/:public_id/registration/new" do
    it "renders the registration form" do
      get reservations_reservation_signup_path(permalink: team.permalink, public_id: reservation.public_id)

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /reservations/:public_id/registration" do
    context "with valid phone number and email" do
      it "invites the customer and redirects with a notice" do
        expect {
          post reservations_reservation_signup_create_path(permalink: team.permalink, public_id: reservation.public_id), params: {
            customer: {
              phone_number: "09012345678",
              email: "valid@example.com"
            }
          }
        }.to change { ActionMailer::Base.deliveries.count }.by(1)

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to be_present
      end
    end

    context "with invalid phone number" do
      it "renders the form again with an alert" do
        post reservations_reservation_signup_create_path(permalink: team.permalink, public_id: reservation.public_id), params: {
          customer: {
            phone_number: "0000000000",
            email: "valid@example.com"
          }
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash[:alert]).to be_present
      end
    end

    context "with invalid email format" do
      it "renders the form again with an alert" do
        post reservations_reservation_signup_create_path(permalink: team.permalink, public_id: reservation.public_id), params: {
          customer: {
            phone_number: "09012345678",
            email: "invalid-email"
          }
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash[:alert]).to be_present
      end
    end
  end
end

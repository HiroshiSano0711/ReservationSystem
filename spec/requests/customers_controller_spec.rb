require "rails_helper"

RSpec.describe CustomersController, type: :request do
  describe "GET /customers/new" do
    it "returns a successful response" do
      get customers_new_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /customers/invite" do
    let(:valid_params) { { customer: { email: "test@example.com" } } }
    let(:invalid_params) { { customer: { email: "invalid-email" } } }

    context "with valid email" do
      it "invites the customer and redirects with notice" do
        expect {
          post customers_path, params: valid_params
        }.to change(ActionMailer::Base.deliveries, :count).by(1)

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to be_present
      end
    end

    context "with invalid email" do
      it "does not invite and re-renders the new template with alert" do
        expect {
          post customers_path, params: invalid_params
        }.not_to change(ActionMailer::Base.deliveries, :count)

        expect(response).to render_template(:new)
        expect(flash[:alert]).to be_present
      end
    end
  end
end

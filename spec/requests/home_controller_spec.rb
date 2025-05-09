require "rails_helper"

RSpec.describe HomeController, type: :request do
  describe "GET /" do
    it "returns a successful response" do
      get root_path

      expect(response).to have_http_status(:success)
    end
  end
end

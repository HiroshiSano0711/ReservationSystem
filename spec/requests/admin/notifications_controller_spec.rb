require "rails_helper"

RSpec.describe Admin::NotificationsController, type: :request do
  include_context "admin access setup"

  describe "admin access" do
    it "inherits from Admin::BaseController" do
      expect(described_class < Admin::BaseController).to be true
    end

    it_behaves_like "admin-only access" do
      let(:path) { admin_notifications_path }
    end
  end

  describe "action" do
    before do
      sign_in admin, scope: :staff
    end

    describe "GET /admin/notifications" do
      it "returns a successful response" do
        get admin_notifications_path

        expect(response).to have_http_status(:success)
      end
    end

    describe "PATCH /admin/notifications/:id/mark_as_read" do
      it "marks the notification as read and redirects to the action URL" do
        allow(Time.zone).to receive(:today).and_return(FIXED_TIME.call.to_date)

        reservation = create(:reservation, team: team)
        notification = create(:notification, team: team, reservation: reservation, is_read: false, action_url: "http://localhost:3000/admin/reservations/#{reservation.id}")

        patch mark_as_read_admin_notification_path(id: notification.id)

        notification.reload
        expect(notification.is_read).to be_truthy
        expect(response).to redirect_to(URI.parse(notification.action_url).path)
      end
    end
  end
end

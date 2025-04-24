require "rails_helper"

RSpec.describe Notification, type: :model do
  describe "associations" do
    it { should belong_to(:team) }
    it { should belong_to(:receiver).class_name("Staff") }
    it { should belong_to(:reservation) }
  end

  describe "enums" do
    it {
      should define_enum_for(:notification_type)
        .with_values(reservation_created: 1, reservation_canceled: 2)
    }
  end

  describe "validations" do
    before { allow(Time.zone).to receive(:today).and_return(FIXED_TIME.call.to_date) }

    it "is valid with valid attributes" do
      reservation = create(:reservation)
      admin_staff = create(:staff, role: :admin_staff, team: reservation.team)
      notification = Notification.new(
        team: reservation.team,
        reservation: reservation,
        receiver: admin_staff,
        notification_type: :reservation_created,
        action_url: "https://example.com"
      )
      expect(notification).to be_valid
    end

    it { should validate_presence_of(:notification_type) }

    context "action_url" do
      it { should validate_presence_of(:action_url) }

      it "is valid with a valid URL" do
        valid_urls = %w[http://example.com https://example.com]
        valid_urls.each do |url|
          notification = build(:notification, action_url: url)
          expect(notification).to be_valid
        end
      end

      it "is invalid with an invalid URL" do
        invalid_urls = %w[example.com invalid-url]
        invalid_urls.each do |url|
          notification = build(:notification, action_url: url)
          expect(notification).to be_invalid
          expect(notification.errors[:action_url]).to include("はURL形式でなければいけません")
        end
      end
    end
  end
end

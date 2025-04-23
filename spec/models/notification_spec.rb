require "rails_helper"

RSpec.describe Notification, type: :model do
  describe "associations" do
    it { should belong_to(:team) }
    it { should belong_to(:receiver).class_name('Staff') }
    it { should belong_to(:reservation) }
  end

  describe "enums" do
    it {
      should define_enum_for(:notification_type)
        .with_values(reservation_created: 1, reservation_canceled: 2)
    }
  end

  describe "validations" do
    it "is valid with valid attributes" do
      allow(Time.zone).to receive(:today).and_return(FIXED_TIME.call.to_date)

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

    it { should validate_presence_of(:action_url) }
    it { should validate_presence_of(:notification_type) }
  end
end

require "rails_helper"

RSpec.describe Notification, type: :model do
  describe "associations" do
    it { should belong_to(:team) }
  end

  describe "enums" do
    it {
      should define_enum_for(:notification_type)
        .with_values(reservation_created: 1, reservation_canceled: 2)
    }

    it { should define_enum_for(:status).with_values(unread: 0, read: 1) }
  end

  describe "validations" do
    it { should validate_presence_of(:receiver_id) }
    it { should validate_presence_of(:message) }
    it { should validate_presence_of(:action_url) }
    it { should validate_presence_of(:notification_type) }
    it { should validate_presence_of(:status) }
  end
end

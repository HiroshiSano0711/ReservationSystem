require "rails_helper"

RSpec.describe Reservation, type: :model do
  describe "associations" do
    it { should belong_to(:team) }
    it { should belong_to(:customer).optional }
    it { should have_many(:details).dependent(:destroy) }
    it { should have_many(:staffs).through(:details) }
  end

  describe "validations" do
    context "for consistency" do
      it { should validate_presence_of(:public_id) }
      it { should validate_presence_of(:start_time) }
      it { should validate_presence_of(:end_time) }
      it { should validate_presence_of(:status) }
      it { should validate_presence_of(:customer_name) }
      it { should validate_presence_of(:customer_phone_number) }
      it { should validate_presence_of(:total_price) }
      it { should validate_presence_of(:total_duration) }
      it { should validate_presence_of(:required_staff_count) }
      it { should validate_presence_of(:menu_summary) }
      it { should validate_presence_of(:assigned_staff_name) }
    end
  end
end

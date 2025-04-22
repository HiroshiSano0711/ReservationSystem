require "rails_helper"

RSpec.describe ReservationDetail, type: :model do
  describe "associations" do
    it { should belong_to(:reservation) }
    it { should belong_to(:staff).optional }
    it { should belong_to(:service_menu) }
  end

  describe "validations" do
    it { should validate_presence_of(:menu_name) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:duration) }
    it { should validate_presence_of(:required_staff_count) }
  end
end

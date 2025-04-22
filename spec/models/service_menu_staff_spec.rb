require "rails_helper"

RSpec.describe ServiceMenuStaff, type: :model do
  describe "associations" do
    it { should belong_to(:service_menu) }
    it { should belong_to(:staff) }
  end

  describe "validations" do
    subject { create(:service_menu_staff) }

    it { should validate_uniqueness_of(:staff_id).scoped_to(:service_menu_id) }
  end
end

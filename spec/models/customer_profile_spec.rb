require "rails_helper"

RSpec.describe CustomerProfile, type: :model do
  describe "associations" do
    it { should belong_to(:customer) }
  end

  describe 'validations' do
    it "is valid with valid attributes" do
      customer_profile = CustomerProfile.new(
        customer: create(:customer),
        name: 'Test Customer',
        phone_number: '09012345678'
      )
      expect(customer_profile).to be_valid
    end

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:phone_number) }
  end
end

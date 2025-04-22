require "rails_helper"

RSpec.describe Customer, type: :model do
  describe "devise modules" do
    it "includes Devise modules" do
      expect(Customer.devise_modules).to include(
        :database_authenticatable,
        :recoverable,
        :validatable,
        :rememberable,
        :invitable
      )
    end
  end

  describe "associations" do
    it { should have_one(:customer_profile).dependent(:destroy) }
    it { should have_many(:reservations) }
  end

  describe "validations" do
    subject { build(:customer) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password) }
  end
end

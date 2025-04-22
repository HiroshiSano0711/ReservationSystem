require 'rails_helper'

RSpec.describe Staff, type: :model do
  describe 'devise modules' do
    it 'includes Devise modules' do
      expect(Staff.devise_modules).to include(
        :database_authenticatable,
        :recoverable,
        :validatable,
        :invitable
      )
    end
  end

  describe 'associations' do
    it { should belong_to(:team) }
    it { should have_one(:staff_profile).dependent(:destroy) }
    it { should have_many(:service_menu_staffs) }
    it { should have_many(:service_menus).through(:service_menu_staffs) }
    it { should have_many(:reservation_details) }
    it { should have_many(:reservations).through(:reservation_details) }
  end

  describe 'validations' do
    subject { build(:staff) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password) }
  end

  describe 'enums' do
    it { should define_enum_for(:role).with_values(admin_staff: 0, staff: 1) }
  end
end

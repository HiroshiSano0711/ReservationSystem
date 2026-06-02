require 'rails_helper'

RSpec.describe Forms::Reservations::Finalization, type: :model do
  describe '#persisted?' do
    it 'returns false' do
      expect(described_class.new.persisted?).to eq(false)
    end
  end

  describe 'validations' do
    it 'is invalid without customer_name' do
      form = described_class.new(
        customer_name: nil,
        customer_phone_number: '09012345678'
      )

      expect(form).to be_invalid
      expect(form.errors[:customer_name]).to be_present
    end

    it 'is invalid without customer_phone_number' do
      form = described_class.new(
        customer_name: '山田 太郎',
        customer_phone_number: nil
      )

      expect(form).to be_invalid
      expect(form.errors[:customer_phone_number]).to be_present
    end

    it 'is valid with both customer_name and customer_phone_number' do
      form = described_class.new(
        customer_name: '山田 太郎',
        customer_phone_number: '09012345678'
      )

      expect(form).to be_valid
    end
  end
end

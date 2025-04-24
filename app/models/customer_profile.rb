class CustomerProfile < ApplicationRecord
  belongs_to :customer

  validates :name, :phone_number, presence: true
end

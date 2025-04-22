class CustomerProfile < ApplicationRecord
  belongs_to :customer

  validates :name, presence: true
  validates :phone_number, presence: true
end

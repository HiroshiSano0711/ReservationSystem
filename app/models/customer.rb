class Customer < ApplicationRecord
  has_one :customer_profile
  has_many :reservations
end

class Customer < ApplicationRecord
  devise :database_authenticatable, :recoverable, :validatable, :invitable, :rememberable

  has_one :customer_profile, dependent: :destroy
  has_many :reservations
end

class Customer < ApplicationRecord
  devise :database_authenticatable, :recoverable, :validatable, :invitable, :rememberable

  has_one :profile, class_name: "CustomerProfile", foreign_key: "customer_id", dependent: :destroy
  has_many :reservations
end

class Customer < ApplicationRecord
  has_one :customer_profile
  has_many :reservations
  validates :email, uniqueness: true, unless: :dummy_email?

  private

  def dummy_email?
    email === 'dummy-email@example.com'
  end
end

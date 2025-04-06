class Reservation < ApplicationRecord
  belongs_to :team
  belongs_to :customer
  has_many :reservation_details
end

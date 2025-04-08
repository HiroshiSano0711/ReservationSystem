class Reservation < ApplicationRecord
  belongs_to :team
  belongs_to :customer, optional: true
  has_many :reservation_details
  has_many :staffs, through: :reservation_details

  enum :status, { temporary: 0, finalize: 1, canceled: 99 }
end

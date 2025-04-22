class ReservationDetail < ApplicationRecord
  belongs_to :reservation
  belongs_to :staff, optional: true
  belongs_to :service_menu

  validates :price, presence: true
  validates :duration, presence: true
  validates :required_staff_count, presence: true
end

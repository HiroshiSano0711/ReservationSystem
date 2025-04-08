class ReservationDetail < ApplicationRecord
  belongs_to :reservation
  belongs_to :staff, optional: true
  belongs_to :service_menu
end

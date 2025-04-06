class ReservationDetail < ApplicationRecord
  belongs_to :reservation
  belongs_to :staff_id
end

class ReservationStaffAssignment < ApplicationRecord
  belongs_to :reservation_detail
  belongs_to :staff
end

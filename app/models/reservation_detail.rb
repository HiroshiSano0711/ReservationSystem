class ReservationDetail < ApplicationRecord
  belongs_to :reservation
  belongs_to :service_menu
  has_many :staff_assignments, class_name: "ReservationStaffAssignment", dependent: :destroy
  has_many :staffs, through: :staff_assignments

  validates :price, presence: true
  validates :duration, presence: true
  validates :required_staff_count, presence: true
end

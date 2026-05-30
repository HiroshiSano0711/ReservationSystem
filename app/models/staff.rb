class Staff < ApplicationRecord
  devise :database_authenticatable, :recoverable, :validatable, :invitable

  belongs_to :team
  has_many :service_menu_staffs
  has_many :service_menus, through: :service_menu_staffs
  has_many :staff_assignments, class_name: "ReservationStaffAssignment", foreign_key: "staff_id"
  has_many :reservation_details, through: :staff_assignments
  has_many :reservations, through: :reservation_details
  has_one :profile, class_name: "StaffProfile", foreign_key: "staff_id", dependent: :destroy

  enum :role, { admin_staff: 0, general: 1 }
end

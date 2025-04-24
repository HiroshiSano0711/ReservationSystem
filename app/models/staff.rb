class Staff < ApplicationRecord
  devise :database_authenticatable, :recoverable, :validatable, :invitable

  belongs_to :team
  has_one :staff_profile, dependent: :destroy
  has_many :service_menu_staffs
  has_many :service_menus, through: :service_menu_staffs
  has_many :reservation_details
  has_many :reservations, through: :reservation_details

  enum :role, { admin_staff: 0, general: 1 }
end

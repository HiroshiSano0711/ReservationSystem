class ServiceMenuStaff < ApplicationRecord
  belongs_to :service_menu
  belongs_to :staff

  validates :staff_id, uniqueness: { scope: :service_menu_id }
end

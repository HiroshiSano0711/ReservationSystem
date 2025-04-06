class ServiceMenu < ApplicationRecord
  belongs_to :team
  has_many :service_menu_staffs
  has_many :staffs, through: :service_menu_staffs
end

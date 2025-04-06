class ServiceMenuStaff < ApplicationRecord
  belongs_to :service_menu
  belongs_to :staff
end

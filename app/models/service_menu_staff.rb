class ServiceMenuStaff < ApplicationRecord
  belongs_to :service_menu
  belongs_to :staff

  validates :priority, presence: true, numericality: { only_integer: true }
end

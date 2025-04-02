class ServiceMenuUser < ApplicationRecord
  belongs_to :service_menu
  belongs_to :user
end

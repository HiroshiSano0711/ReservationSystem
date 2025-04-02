class ServiceMenu < ApplicationRecord
  belongs_to :team
  has_many :service_menu_users
  has_many :users, through: :service_menu_users
end

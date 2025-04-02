class Team < ApplicationRecord
  has_many :users
  has_many :service_menus
  has_one :team_business_setting
end

class Team < ApplicationRecord
  has_many :users
  has_one :team_business_setting
end

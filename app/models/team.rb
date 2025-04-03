class Team < ApplicationRecord
  validates :permalink, presence: true,
                        uniqueness: true,
                        format: { with: /\A[a-z0-9]+(?:-[a-z]+[a-z0-9]*)+\z/, message: "はハイフンを含めてください" },
                        length: { minimum: 5, maximum: 32 }
  has_many :users
  has_many :service_menus
  has_one :team_business_setting
end

class Team < ApplicationRecord
  has_one :team_business_setting
  has_many :reservations
  has_many :staffs
  has_many :service_menus

  validates :permalink,
    presence: true,
    uniqueness: true,
    format: {
      with: /\A[a-z0-9]+(?:-[a-z]+[a-z0-9]*)+\z/,
      message: "はハイフンを含めてください"
    },
    length: { minimum: 5, maximum: 32 }

  def reservation_url(req)
    "#{req.protocol}#{req.host_with_port}/#{permalink}"
  end
end

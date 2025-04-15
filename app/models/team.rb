class Team < ApplicationRecord
  has_one :team_business_setting
  has_one_attached :image
  has_many :reservations
  has_many :staffs
  has_many :service_menus
  has_many :notifications

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

  def admin_staff
    Staff.find_by(team: id, role: :admin_staff)
  end
end

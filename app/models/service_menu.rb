class ServiceMenu < ApplicationRecord
  belongs_to :team
  has_many :service_menu_staffs
  has_many :staffs, through: :service_menu_staffs
  has_many :reservation_details

  def available?
    available_from <= Time.zone.now && (available_until.blank? || available_until >= Time.zone.now)
  end

  scope :available, -> { where("available_from <= ? AND (available_until IS NULL OR available_until >= ?)", Time.zone.now, Time.zone.now) }
  scope :unavailable, -> { where("available_from > ? OR available_until < ?", Time.zone.now, Time.zone.now) }
end

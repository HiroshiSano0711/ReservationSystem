class ServiceMenu < ApplicationRecord
  belongs_to :team
  has_many :service_menu_staffs
  has_many :staffs, through: :service_menu_staffs
  has_many :reservation_details

  validates :name, presence: true, uniqueness: { scope: :team_id }
  validates :duration, :price, :required_staff_count, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :available_from, presence: true

  validate :duration_in_5_minute_units

  def available?
    available_from <= Time.zone.now && (available_until.blank? || available_until >= Time.zone.now)
  end

  scope :available, -> { where("available_from <= ? AND (available_until IS NULL OR available_until >= ?)", Time.zone.now, Time.zone.now) }
  scope :unavailable, -> { where("available_from > ? OR available_until < ?", Time.zone.now, Time.zone.now) }

  private

  def duration_in_5_minute_units
    return if duration.nil?

    unless duration % 5 == 0
      errors.add(:duration, "は5分単位で指定してください")
    end
  end
end

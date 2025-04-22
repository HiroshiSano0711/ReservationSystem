class WeeklyBusinessHour < ApplicationRecord
  belongs_to :team_business_setting
  enum :wday, { sun: 0, mon: 1, tue: 2, wed: 3, thu: 4, fri: 5, sat: 6 }

  WDAYS = %i[sun mon tue wed thu fri sat]

  validates :wday, presence: true
  validates :open, presence: true
  validates :close, presence: true
  validate :validate_close_after_open

  private

  def validate_close_after_open
    return if open.blank? || close.blank?

    if close <= open
      errors.add(:close, "はオープンより後の時間にしてください")
    end
  end
end

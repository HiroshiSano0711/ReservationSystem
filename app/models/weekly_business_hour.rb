class WeeklyBusinessHour < ApplicationRecord
  belongs_to :team_business_setting
  enum :wday, { sun: 0, mon: 1, tue: 2, wed: 3, thu: 4, fri: 5, sat: 6 }

  WDAYS = %i[sun mon tue wed thu fri sat]

  validates :wday, presence: true
  validates :working_day, inclusion: { in: [true, false] }
  validates :open, presence: true
  validates :close, presence: true
  validate :close_after_open

  private

  def close_after_open
    if close <= open
      errors.add(:close, "はオープンより後の時間にしてください")
    end
  end
end

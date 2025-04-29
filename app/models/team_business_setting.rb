class TeamBusinessSetting < ApplicationRecord
  belongs_to :team
  has_many :weekly_business_hours, dependent: :destroy

  validates :max_reservation_month, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :reservation_start_delay_days,
            :cancellation_deadline_hours_before,
            presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def weekly_business_hour_for(date)
    weekly_business_hours.find_by(wday: date.wday)
  end

  def working_day?(date)
    hour = weekly_business_hour_for(date)
    hour&.working_day?
  end

  def opening_hours(date)
    business_hour = weekly_business_hour_for(date)
    {
      open: Time.zone.parse("#{date} #{business_hour.open.strftime("%H:%M")}"),
      close: Time.zone.parse("#{date} #{business_hour.close.strftime("%H:%M")}")
    }
  end
end

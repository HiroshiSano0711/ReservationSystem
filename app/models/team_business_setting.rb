class TeamBusinessSetting < ApplicationRecord
  belongs_to :team
  has_many :weekly_business_hours, dependent: :destroy

  validates :max_reservation_month, presence: true
  validates :reservation_start_delay_days, presence: true
  validates :cancellation_deadline_hours_before, presence: true

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
      open: Time.zone.parse("#{date} #{hbusiness_hourour.open.strftime("%H:%M")}"),
      close: Time.zone.parse("#{date} #{business_hour.close.strftime("%H:%M")}")
    }
  end
end

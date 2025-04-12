class Reservation < ApplicationRecord
  belongs_to :team
  belongs_to :customer, optional: true
  has_many :reservation_details
  has_many :staffs, through: :reservation_details

  enum :status, { temporary: 0, finalize: 1, canceled: 99 }

  validate :start_date_within_allowed_range, on: :create
  validate :end_date_within_allowed_range, on: :create

  private

  def start_date_within_allowed_range
    earliest_possible_start_time = Time.zone.now + team.business_setting.reservation_start_delay_days.days
    if start_time < earliest_possible_start_time
      errors.add(:start_time, "予約は#{team.business_setting.reservation_start_delay_days}日後からしか受付けられません。")
    end
  end

  def end_date_within_allowed_range
    possible_end_time = Time.zone.now + team.business_setting.max_reservation_month.months
    if start_time > possible_end_time
      errors.add(:start_time, "予約は#{team.business_setting.max_reservation_month}ヶ月後までしか受付けられません。")
    end
  end
end

class Reservation < ApplicationRecord
  belongs_to :team
  belongs_to :customer, optional: true
  has_many :reservation_details
  has_many :staffs, through: :reservation_details

  enum :status, { temporary: 0, finalize: 1, canceled: 99 }

  validate :start_date_within_allowed_range, on: :create
  validate :end_date_within_allowed_range, on: :create
  validate :customer_does_not_have_overlapping_reservations, if: -> { customer_id.present? }

  private

  def start_date_within_allowed_range
    possible_start_date = Time.zone.today + team.team_business_setting.reservation_start_delay_days.days
    if date < possible_start_date
      errors.add(:start_time, "予約は#{team.team_business_setting.reservation_start_delay_days}日後からしか受付けられません。")
    end
  end

  def end_date_within_allowed_range
    possible_end_date = Time.zone.today + team.team_business_setting.max_reservation_month.months
    if date > possible_end_date
      errors.add(:start_time, "予約は#{team.team_business_setting.max_reservation_month}ヶ月後までしか受付けられません。")
    end
  end

  def customer_does_not_have_overlapping_reservations
    overlapping = Reservation.where(customer_id: customer_id)
                             .where.not(id: id)
                             .where("start_time < ? AND end_time > ?", end_time, start_time)
                             .exists?

    if overlapping
      errors.add(:base, "すでにこの時間帯に予約があります。")
    end
  end
end

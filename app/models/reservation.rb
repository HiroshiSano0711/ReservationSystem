class Reservation < ApplicationRecord
  belongs_to :team
  belongs_to :customer, optional: true
  has_many :reservation_details, dependent: :destroy
  has_many :staffs, through: :reservation_details

  enum :status, { finalize: 1, canceled: 99 }

  validates :public_id, presence: true, uniqueness: true
  validates :date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :customer_name, presence: true
  validates :customer_phone_number, presence: true
  validates :total_price, presence: true
  validates :total_duration, presence: true
  validates :required_staff_count, presence: true
  validates :menu_summary, presence: true
  validates :assigned_staff_name, presence: true
  validates :status, presence: true
  validate :start_date_within_allowed_range, on: :create
  validate :end_date_within_allowed_range, on: :create
  validate :customer_does_not_have_overlapping_reservations, if: -> { customer_id.present? }

  def cancelable?
    cacel_deadline_time = Time.zone.now + team.team_business_setting.cancellation_deadline_hours_before.hours
    r_start_time = Time.zone.parse("#{date} #{start_time}")
    cacel_deadline_time < r_start_time
  end

  private

  def start_date_within_allowed_range
    return if date.blank? || team.blank?

    possible_start_date = Time.zone.today + team.team_business_setting.reservation_start_delay_days.days
    if date < possible_start_date
      errors.add(:start_time, "予約は#{team.team_business_setting.reservation_start_delay_days}日後からしか受付けられません。")
    end
  end

  def end_date_within_allowed_range
    return if date.blank? || team.blank?

    possible_end_date = Time.zone.today + team.team_business_setting.max_reservation_month.months
    if date > possible_end_date
      errors.add(:start_time, "予約は#{team.team_business_setting.max_reservation_month}ヶ月後までしか受付けられません。")
    end
  end

  def customer_does_not_have_overlapping_reservations
    overlapping = Reservation.where(customer_id: customer_id)
                             .where.not(id: id)
                             .where(date: date)
                             .where("start_time < ? AND end_time > ?", end_time, start_time)
                             .exists?

    if overlapping
      errors.add(:base, "すでに予約している時間帯と重複しています。")
    end
  end
end

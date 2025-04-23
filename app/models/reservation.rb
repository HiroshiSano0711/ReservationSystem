class Reservation < ApplicationRecord
  belongs_to :team
  belongs_to :customer, optional: true
  has_many :reservation_details, dependent: :destroy
  has_many :staffs, through: :reservation_details

  enum :status, { finalize: 1, canceled: 99 }

  validates :public_id, presence: true, uniqueness: true
  validates :date, :start_time, :end_time, :status, :customer_name, :customer_phone_number,
            :total_price, :total_duration, :required_staff_count, :menu_summary, :assigned_staff_name,
            presence: true

  validate :validate_reservation_rules, on: :create

  def cancelable?
    cacel_deadline_time = Time.zone.now + team.team_business_setting.cancellation_deadline_hours_before.hours
    r_start_time = Time.zone.parse("#{date} #{start_time}")
    cacel_deadline_time < r_start_time
  end

  private

  def validate_reservation_rules
    ReservationValidator.new(self).validate
  end
end

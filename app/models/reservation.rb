class Reservation < ApplicationRecord
  belongs_to :team
  belongs_to :customer, optional: true
  has_many :details, class_name: "ReservationDetail", foreign_key: "reservation_id", dependent: :destroy
  has_many :staffs, through: :details

  enum :status, { finalized: 1, canceled: 99 }

  # 整合性のための条件
  validates :public_id, presence: true, uniqueness: true
  validates :start_time, :end_time, :status, presence: true

  # 整合性のための条件（スナップショット）
  validates :customer_name,
            :customer_phone_number,
            :total_price,
            :total_duration,
            :required_staff_count,
            :menu_summary,
            :assigned_staff_name,
            presence: true

  # 不変条件
  validates :total_price, :total_duration, :required_staff_count, numericality: { greater_than: 0 }
  validate :start_time_must_be_before_end_time

  private

  def start_time_must_be_before_end_time
    return if start_time.blank? || end_time.blank?

    errors.add(:start_time, "は終了時間より前でなければなりません") if start_time >= end_time
  end
end

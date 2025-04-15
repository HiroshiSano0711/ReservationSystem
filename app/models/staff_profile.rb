class StaffProfile < ApplicationRecord
  belongs_to :staff
  has_one_attached :image

  enum :working_status, { active: 0, leave_on: 1, retire: 99 }
  validates :nick_name, presence: true, on: :update
end

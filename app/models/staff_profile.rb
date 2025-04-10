class StaffProfile < ApplicationRecord
  belongs_to :staff
  enum :working_status, { active: 0, leave_on: 1, retire: 99 }

  validates :nick_name, presence: true, on: :update
end

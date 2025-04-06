class StaffProfile < ApplicationRecord
  belongs_to :staff
  enum :working_status, { active: 0, retire: 1, leave_on: 2 }

  validates :nick_name, presence: true, on: :update
end

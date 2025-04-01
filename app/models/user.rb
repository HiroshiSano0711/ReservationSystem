class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable
  belongs_to :team
  enum :role, { admin_staff: 0, staff: 1 }
  enum :status, { active: 0, retire: 1, leave_on: 2 }

end

class Notification < ApplicationRecord
  belongs_to :team

  enum :notification_type, { reservation_created: 1, reservation_canceled: 2 }
  enum :status, { unread: 0, read: 1 }

  validates :receiver_id, presence: true
  validates :notification_type, presence: true
  validates :status, presence: true
  validates :message, presence: true
  validates :action_url, presence: true
end

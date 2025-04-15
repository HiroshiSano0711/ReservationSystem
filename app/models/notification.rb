class Notification < ApplicationRecord
  belongs_to :team

  enum :notification_type, { reservation_created: 1, reservation_canceled: 2 }
  enum :status, { unread: 0, read: 1 }
end

class Notification < ApplicationRecord
  enum :notification_type, { reservation_created: 1, reservation_canceled: 2 }
  enum :status, { unread: 1, read: 2 }
end

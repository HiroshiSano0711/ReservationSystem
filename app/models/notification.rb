class Notification < ApplicationRecord
  belongs_to :team
  belongs_to :reservation
  belongs_to :receiver, class_name: 'Staff'

  enum :notification_type, { reservation_created: 1, reservation_canceled: 2 }

  validates :notification_type, presence: true
  validates :action_url, presence: true, format: {
    with: URI::DEFAULT_PARSER.make_regexp,
    message: "はURL形式でなければいけません"
  }
end

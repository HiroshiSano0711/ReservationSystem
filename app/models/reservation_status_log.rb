class ReservationStatusLog < ApplicationRecord
  belongs_to :reservation

  enum :changed_by, { system: 0, admin: 1, customer: 99 }
  enum :from_status, { finalized: 1, canceled: 99 }, prefix: :from
  enum :to_status, { finalized: 1, canceled: 99 }, prefix: :to
end

module Reservations
  class FinalizationForm
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :customer_name, :string
    attribute :customer_phone_number, :string

    validates :customer_name, :customer_phone_number, presence: true
  end
end

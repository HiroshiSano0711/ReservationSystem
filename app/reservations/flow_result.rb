module Reservations
  class FlowResult
    attr_reader :message, :resource

    def initialize(success:, message: nil, resource: nil)
      @success = success
      @message = message
      @resource = resource
    end

    def success?
      @success
    end
  end
end

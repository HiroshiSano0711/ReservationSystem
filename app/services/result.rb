module Services
  class Result
    attr_reader :resource, :message

    def initialize(success:, resource: nil, message: nil)
      @success = success
      @resource = resource
      @message = message
    end

    def success?
      @success
    end
  end
end

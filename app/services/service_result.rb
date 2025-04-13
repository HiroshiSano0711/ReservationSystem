class ServiceResult
  attr_reader :data, :message

  def initialize(success:, data: nil, message: nil)
    @success = success
    @data = data
    @message = message
  end

  def success?
    @success
  end
end

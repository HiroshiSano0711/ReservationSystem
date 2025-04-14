class AbstractMethodNotImplementedError < StandardError
  def initialize(klass:, method:)
    super("#{klass} must implement ##{method}")
  end
end

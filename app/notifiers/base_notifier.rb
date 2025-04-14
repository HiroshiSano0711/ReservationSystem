class BaseNotifier
  include Rails.application.routes.url_helpers

  def self.send(context:, attr:)
    new(context: context, attr: attr).send
  rescue => e
    Rails.logger.error("[NotificationError] #{e.class} - #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    nil
  end

  def initialize(context:, attr:)
    @context = context
    @attr = attr
    validate_attr
    @build_context = build_context
  end

  def send
    notification = create_notification
    NotificationSender.send(notification, @context)
  end

  private

  def validate_attr
    raise ArgumentError, "Expected #{@attr.class} to be an instance of #{attr_class}" unless @attr.is_a?(attr_class)
    raise ArgumentError, "Missing necessary attribute data" if @attr.blank?
  end

  def build_context
    raise AbstractMethodNotImplementedError.new(klass: self.class, method: :build_context)
  end

  def attr_class
    raise AbstractMethodNotImplementedError.new(klass: self.class, method: :attr_class)
  end

  def create_notification
    Notification.create!(build_context)
  end
end

class BaseNotifier
  include Rails.application.routes.url_helpers
  NOTIFIER_SYSTEM_USER = NotifierSystemUser.new.freeze

  def default_url_options
    Rails.application.default_url_options
  end

  def self.send(team:, attr:)
    new(team: team, attr: attr).notify
  rescue => e
    Rails.logger.error("[NotificationError] #{e.class} - #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    nil
  end

  def initialize(team:, attr:)
    @team = team
    @attr = attr
  end

  def notify
    validate_attr
    context = build_context
    notification = Notification.create!(context[:notification_attr])
    NotificationSender.send(notification, context)
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
end

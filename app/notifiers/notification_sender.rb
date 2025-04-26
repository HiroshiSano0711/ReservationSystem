class NotificationSender
  include Rails.application.routes.url_helpers

  def initialize(team:, reservation:, notification_type:)
    @team = team
    @reservation = reservation
    @notification_type = notification_type
    @receiver = team.admin_staff
  end

  def default_url_options
    Rails.application.config.action_mailer.default_url_options
  end

  def call
    send_notification
  rescue => e
    Rails.logger.error("NotificationSenderError: #{e.class} - #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
  end

  private

  def send_notification
    notification = Notification.create!(
      team: @team,
      receiver: @receiver,
      reservation: @reservation,
      is_read: false,
      notification_type: @notification_type,
      action_url: admin_reservation_url(public_id: @reservation.public_id)
    )

    NotificationMailer.public_send(
      @notification_type,
      receiver: @receiver,
      reservation: @reservation,
      action_url: notification.action_url
    ).deliver_later
  end
end

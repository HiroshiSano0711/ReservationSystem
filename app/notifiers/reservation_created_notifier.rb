class ReservationCreatedNotifier < BaseNotifier
  private

  def attr_class
    Reservation
  end

  def build_context
    receiver = @team.admin_staff
    sender = NOTIFIER_SYSTEM_USER
    {
      receiver: receiver,
      sender: sender,
      notification_attr: {
        team: @team,
        sender_id: sender.id,
        receiver_id: receiver.id,
        status: :unread,
        notification_type: Notification.notification_types[:reservation_created],
        message: "#{@attr.customer_name}さんから予約が入りました。",
        action_url: admin_reservation_url(public_id: @attr.public_id)
      }
    }
  end
end

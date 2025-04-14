class ReservationCanceledNotifier < BaseNotifier
  def attr_class
    Reservation
  end

  private

  def build_context
    {
      sender_id: @context[:current_customer]&.id || NotifierSystemUser.new.id,
      receiver_id: @context[:admin_staff].id,
      status: :unread,
      notification_type: Notification.notification_types[:reservation_created],
      message: "#{@attr.customer_name}さんが予約をキャンセルしました。",
      action_url: admin_reservation_url(public_id: @attr.public_id)
    }
  end
end

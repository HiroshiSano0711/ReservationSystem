module Services
  module Reservations
    class SessionWrapper
      delegate :[], :[]=, :delete, to: :@session

      def initialize(session)
        @session = session
      end

      def save_menu_select(form)
        self[:selected_service_menu_ids] = form.single_menu_ids || [ form.multi_staff_menu_id ]
        self[:selected_staff_id] = form.selected_staff
      end

      def save_slot(selected_slot)
        self[:selected_slot] = selected_slot
      end

      def save_public_id(public_id)
        clear_selection
        self[:public_id] = public_id
      end

      def clear_selection
        delete(:selected_service_menu_ids)
        delete(:selected_staff_id)
        delete(:selected_slot)
      end

      def clear_public_id
        delete(:public_id)
      end

      def selected_service_menu_ids
        self[:selected_service_menu_ids] || []
      end

      def selected_staff_id   = self[:selected_staff_id]
      def selected_slot = self[:selected_slot]
      def public_id = self[:public_id]
    end
  end
end

module Reservations
  class SessionData
    def initialize(session)
      @session = session
    end

    def selected_service_menu_ids=(menu_ids)
      @session[:selected_service_menus] = menu_ids
    end

    def selected_service_menu_ids
      @session[:selected_service_menus] || []
    end

    def selected_staff_id=(staff_id)
      @session[:selected_staff] = staff_id
    end

    def selected_staff_id
      @session[:selected_staff]
    end

    def selected_slot=(slot_time)
      @session[:selected_slot] = slot_time
    end

    def selected_slot
      @session[:selected_slot]
    end

    def public_id
      @session[:public_id]
    end

    def public_id=(public_id)
      @session[:public_id] = public_id
    end

    def clear_selection
      @session.delete(:selected_service_menus)
      @session.delete(:selected_staff)
      @session.delete(:selected_slot)
    end

    def clear_public_id
      @session.delete(:public_id)
    end
  end
end

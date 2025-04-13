module Reservations
  class SelectMenuAndStaffForm
    include ActiveModel::Model

    attr_accessor :team, :staff_profiles, :service_menu_ids, :multi_staff_menu_id, :selected_staff

    validate :service_menus

    def initialize(attributes = {})
      super
      @staff_profiles = preload_staff_profile
    end

    def available_menus
      @team.service_menus.available
    end

    def single_staff_menus
      available_menus.select { |menu| menu.required_staff_count == 1 }
    end

    def multi_staff_menus
      available_menus.select { |menu| menu.required_staff_count > 1 }
    end

    private

    def preload_staff_profile
      StaffProfile.includes(:staff)
                  .where(staff_id: @team.staffs.ids, accepts_direct_booking: true)
    end

    def service_menus
      if service_menu_ids.blank? && multi_staff_menu_id.blank?
        errors.add(:service_menu_ids, "を1つ選択してください。")
      elsif service_menu_ids.present? && multi_staff_menu_id.present?
        errors.add(:multi_staff_menu_id, "は単独対応メニューと同時に選択できません。")
      end
    end
  end
end

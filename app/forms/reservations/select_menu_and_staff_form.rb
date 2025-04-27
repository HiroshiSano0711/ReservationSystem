module Reservations
  class SelectMenuAndStaffForm
    include ActiveModel::Model

    attr_accessor :team, :staff_profiles, :single_menu_ids, :multi_staff_menu_id, :selected_staff

    validate :validate_service_menus

    def initialize(attributes = {})
      super
      @staff_profiles = preload_staff_profile
    end

    def available_menus
      team.service_menus.available
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
                  .where(staff_id: team.staffs.ids, accepts_direct_booking: true)
    end

    def validate_service_menus
      unless single_menu_ids.is_a?(Array)
        errors.add(:single_menu_ids, "は不正な形式です")
        return
      end

      menu_ids = single_menu_ids.reject { |e| e.to_s.blank? }
      if menu_ids.blank? && multi_staff_menu_id.blank?
        errors.add(:single_menu_ids, "を1つ選択してください。")
      elsif menu_ids.present? && multi_staff_menu_id.present?
        errors.add(:multi_staff_menu_id, "は単独対応メニューと同時に選択できません。")
      end
    end
  end
end

class StaffProfileForm
  include ActiveModel::Model

  attr_accessor :staff,
                :staff_profile,
                :working_status,
                :nick_name,
                :accepts_direct_booking,
                :bio,
                :team_service_menus,
                :selected_service_menu_ids

  validates :nick_name, presence: true
  validates :accepts_direct_booking, presence: true
  validate :validate_service_menus

  def initialize(staff:, staff_profile:, team_service_menus:, params:)
    @staff = staff
    @staff_profile = staff_profile
    @team_service_menus = team_service_menus

    assign_attributes(params.to_h.symbolize_keys) if params.present?
  end

  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      staff_profile.assign_attributes(
        working_status: working_status,
        nick_name: nick_name,
        accepts_direct_booking: accepts_direct_booking,
        bio: bio
      )
      staff_profile.save!

      current_selected_service_menu_ids = staff.service_menus.ids
      added_selected_service_menu_ids = selected_service_menu_ids.map(&:to_i) - current_selected_service_menu_ids
      removed_selected_service_menu_ids = current_selected_service_menu_ids - selected_service_menu_ids.map(&:to_i)
      staff.service_menus << team_service_menus.where(id: added_selected_service_menu_ids) if added_selected_service_menu_ids.present?
      staff.service_menus.delete(team_service_menus.where(id: removed_selected_service_menu_ids)) if removed_selected_service_menu_ids.present?

      staff.save!
    end

    true
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("StaffProfileForm save failed: #{e.message}")
    false
  end

  private

  def validate_service_menus
    return true if selected_service_menu_ids.blank?

    team_selected_service_menu_ids = @team_service_menus.map(&:id)
    selected_service_menu_ids.each do |id|
      unless team_selected_service_menu_ids.include?(id.to_i)
        errors.add(:service_menus, 'に無効な選択肢があります。')
        return false
      end
    end

    true
  end
end

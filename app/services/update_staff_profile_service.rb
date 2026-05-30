class UpdateStaffProfileService
  def initialize(staff:, form:, service_menus:)
    @staff = staff
    @form = form
    @service_menus = service_menus
  end

  def call
    @form.validate
    @form.errors.add(:selected_service_menu_ids, "サービスメニューに無効な選択肢があります") if service_menus_invalid?
    return failure_result if @form.errors.any?

    ActiveRecord::Base.transaction do
      @staff.profile.update!(
        image: @form.image,
        working_status: @form.working_status,
        nick_name: @form.nick_name,
        bio: @form.bio
      )
      @staff.service_menu_ids = @form.selected_service_menu_ids.map(&:to_i)
      @staff.save!
    end

    ServiceResult.new(success: true, resource: @form, message: I18n.t("services.staff_profile_update_service.success"))
  rescue ActiveRecord::RecordInvalid,
         ActiveRecord::NotNullViolation,
         ActiveRecord::RecordNotUnique => e
    Rails.logger.error("#{self.class} save failed: #{e.message}")
    @form.errors.add(:base, e.message)

    failure_result
  end

  private

  def service_menus_invalid?
    return false if @form.selected_service_menu_ids.blank? || @service_menus.blank?

    valid_ids = @service_menus.map(&:id)
    invalid_ids = @form.selected_service_menu_ids.map(&:to_i) - valid_ids
    invalid_ids.any?
  end

  def failure_result
    ServiceResult.new(success: false, resource: @form, message: I18n.t("services.staff_profile_update_service.failure"))
  end
end

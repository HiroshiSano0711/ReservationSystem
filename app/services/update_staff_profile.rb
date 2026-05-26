class UpdateStaffProfile
  def initialize(staff, form)
    @staff = staff
    @form = form
  end

  def call
    return failure_result if @form.invalid?

    ActiveRecord::Base.transaction do
      @staff.staff_profile.update!(
        image: @form.image,
        working_status: @form.working_status,
        nick_name: @form.nick_name,
        accepts_direct_booking: @form.accepts_direct_booking,
        bio: @form.bio
      )
      @staff.service_menu_ids = @form.selected_service_menu_ids.map(&:to_i)
      @staff.save!
    end

    ServiceResult.new(success: true, data: @form, message: I18n.t("services.staff_profile_update.success"))
  rescue ActiveRecord::RecordInvalid,
         ActiveRecord::NotNullViolation,
         ActiveRecord::RecordNotUnique => e
    @form.errors.add(:base, e.message)

    failure_result
  end

  private

  def failure_result
    ServiceResult.new(success: false, data: @form, message: I18n.t("services.staff_profile_update.failure"))
  end
end

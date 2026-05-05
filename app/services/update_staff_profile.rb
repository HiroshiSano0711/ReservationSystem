class UpdateStaffProfile
  def initialize(form)
    @form = form
  end

  def call
    validate_service_menus
    return ServiceResult.new(success: false, data: @form) if @form.errors.present?

    ActiveRecord::Base.transaction do
      @form.staff_profile.update!(
        image: @form.image,
        working_status: @form.working_status,
        nick_name: @form.nick_name,
        accepts_direct_booking: @form.accepts_direct_booking,
        bio: @form.bio
      )
      staff = @form.staff_profile.staff
      staff.service_menu_ids = @form.selected_service_menu_ids.map(&:to_i)
      staff.save!
    end

    ServiceResult.new(success: true, data: @form)
  rescue ActiveRecord::RecordInvalid,
         ActiveRecord::NotNullViolation,
         ActiveRecord::RecordNotUnique => e
    @form.errors.add(:base, e.message)

    ServiceResult.new(success: false, data: @form)
  end

  private

  def validate_service_menus
    return if @form.selected_service_menu_ids.blank?

    service_menu_ids = @form.service_menus.map(&:id)
    @form.selected_service_menu_ids.each do |id|
      unless service_menu_ids.include?(id.to_i)
        @form.errors.add(:base, "サービスメニューに無効な選択肢があります")
      end
    end
  end
end

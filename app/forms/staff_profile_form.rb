class StaffProfileForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :staff,
                :staff_profile,
                :image,
                :service_menus,
                :selected_service_menu_ids

  attribute :working_status, :string
  attribute :nick_name, :string
  attribute :accepts_direct_booking, :boolean
  attribute :bio, :string

  validates :nick_name, presence: true
  validate :validate_service_menus

  MODEL_ATTR_MAP = {
    staff_profile: %i[image working_status nick_name accepts_direct_booking bio]
  }.freeze

  def initialize(staff:, service_menus:)
    @staff = staff
    @staff_profile = staff.staff_profile
    @service_menus = service_menus

    super(
      working_status: staff_profile.working_status,
      nick_name: staff_profile.nick_name,
      accepts_direct_booking: staff_profile.accepts_direct_booking,
      bio: staff_profile.bio
    )
  end

  def model_class_for(attr)
    case
    when MODEL_ATTR_MAP[:staff_profile].include?(attr)
      StaffProfile
    end
  end

  def save(params)
    assign_attributes(params)

    return false unless valid?

    ActiveRecord::Base.transaction do
      staff_profile.update!(
        image: image,
        working_status: working_status,
        nick_name: nick_name,
        accepts_direct_booking: accepts_direct_booking,
        bio: bio
      )

      current_ids = staff.service_menus.ids
      added_ids = selected_service_menu_ids.map(&:to_i) - current_ids
      removed_ids = current_ids - selected_service_menu_ids.map(&:to_i)
      staff.service_menus << service_menus.where(id: added_ids) if added_ids.present?
      staff.service_menus.delete(service_menus.where(id: removed_ids)) if removed_ids.present?

      staff.save!
    end

    true
  rescue ActiveRecord::RecordInvalid, ActiveRecord::NotNullViolation, ActiveRecord::RecordNotUnique => e
    Rails.logger.error("#{self.model_name} save failed: #{e.message}")
    false
  end

  private

  def validate_service_menus
    return if selected_service_menu_ids.blank?

    service_menu_ids = service_menus.map(&:id)
    selected_service_menu_ids.each do |id|
      unless service_menu_ids.include?(id.to_i)
        errors.add(:base, "サービスメニューに無効な選択肢があります")
      end
    end
  end
end

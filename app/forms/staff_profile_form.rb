class StaffProfileForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  INPUT_FORMS = [
    :image,
    :working_status,
    :nick_name,
    :accepts_direct_booking,
    :bio,
    { selected_service_menu_ids: [] }
  ].freeze

  attr_accessor :staff_profile,
                :service_menus,
                :image,
                :selected_service_menu_ids

  attribute :working_status, :string
  attribute :nick_name, :string
  attribute :accepts_direct_booking, :boolean
  attribute :bio, :string

  validates :nick_name, presence: true
  validate :service_menus_belong_to_team

  def initialize(staff_profile:, service_menus:)
    @staff_profile = staff_profile
    @service_menus = service_menus

    super(
      working_status: staff_profile.working_status,
      nick_name: staff_profile.nick_name,
      accepts_direct_booking: staff_profile.accepts_direct_booking,
      bio: staff_profile.bio
    )
  end

  def persisted?
    true
  end

  def model_class_for(_attr)
    StaffProfile
  end

  private

  def service_menus_belong_to_team
    return if selected_service_menu_ids.blank?

    service_menu_ids = service_menus.map(&:id)
    selected_service_menu_ids.each do |id|
      unless service_menu_ids.include?(id.to_i)
        errors.add(:selected_service_menu_ids, "サービスメニューに無効な選択肢があります")
      end
    end
  end
end

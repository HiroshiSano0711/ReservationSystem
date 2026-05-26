class StaffProfileForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  PERMITED_PARAMS = [
    :image,
    :working_status,
    :nick_name,
    :accepts_direct_booking,
    :bio,
    { selected_service_menu_ids: [] }
  ].freeze

  attr_accessor :staff_profile,
                :image,
                :selected_service_menu_ids

  attribute :working_status, :string
  attribute :nick_name, :string
  attribute :accepts_direct_booking, :boolean
  attribute :bio, :string

  validates :nick_name, presence: true

  def initialize(staff_profile:)
    @staff_profile = staff_profile

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
end

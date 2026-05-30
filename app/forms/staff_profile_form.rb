class StaffProfileForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  PERMITTED_PARAMS = [
    :image,
    :working_status,
    :nick_name,
    :bio,
    { selected_service_menu_ids: [] }
  ].freeze

  attr_reader :staff_profile
  attr_accessor :image,
                :selected_service_menu_ids

  attribute :working_status, :string
  attribute :nick_name, :string
  attribute :bio, :string

  validates :nick_name, presence: true

  def initialize(staff_profile:)
    @staff_profile = staff_profile

    super(
      working_status: @staff_profile.working_status,
      nick_name: @staff_profile.nick_name,
      bio: @staff_profile.bio
    )
  end

  def persisted?
    true
  end

  def model_class_for(_attr)
    StaffProfile
  end
end

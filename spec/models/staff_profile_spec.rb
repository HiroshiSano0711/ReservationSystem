require 'rails_helper'

RSpec.describe StaffProfile, type: :model do
  describe 'associations' do
    it { should belong_to(:staff) }
    it { should have_one_attached(:image) }
  end

  describe 'validations' do
    it { should validate_presence_of(:nick_name).on(:update) }
  end

  describe 'enum' do
    it { should define_enum_for(:working_status).with_values(active: 0, leave_on: 1, retire: 99) }
  end

  describe "image attachment" do
    it "purges the image when staff_profile is destroyed" do
      staff_profile = create(:staff_profile)
      staff_profile.image.attach(
        io: File.open(Rails.root.join("spec/fixtures/image/sample.png")),
        filename: "sample.png",
        content_type: "image/png"
      )

      expect(staff_profile.image).to be_attached

      expect {
        staff_profile.destroy
      }.to change(ActiveStorage::Attachment, :count).by(-1)
    end
  end
end

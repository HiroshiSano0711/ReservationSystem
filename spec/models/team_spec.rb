require 'rails_helper'

RSpec.describe Team, type: :model do
  describe 'associations' do
    it { should have_one(:team_business_setting).dependent(:destroy) }
    it { should have_one(:admin_staff) }
    it { should have_one_attached(:image) }
    it { should have_many(:staffs).dependent(:destroy) }
    it { should have_many(:reservations).dependent(:destroy) }
    it { should have_many(:service_menus).dependent(:destroy) }
    it { should have_many(:notifications).dependent(:destroy) }
  end

  describe 'validation' do
    context 'valid' do
      it "is valid with valid attributes" do
        team = build(:team, name: "Test Team", permalink: 'test-sample')
        expect(team).to be_valid
      end
    end

    describe 'name' do
      context 'presence' do
        it "is invalid without a name" do
          team = build(:team, name: nil)
          expect(team).to be_invalid
          expect(team.errors[:name]).to include("を入力してください")
        end
      end

      context 'uniqueness' do
        it "is invalid with same name" do
          build(:team, name: 'samename').save!
          team = build(:team, name: 'samename')
          expect(team).to be_invalid
          expect(team.errors[:name]).to include("はすでに存在します")
        end
      end
    end

    describe 'permalink' do
      context 'presence' do
        it "is invalid without a permalink" do
          team = build(:team, permalink: nil)
          expect(team).to be_invalid
          expect(team.errors[:permalink]).to include("を入力してください")
        end
      end

      context 'format' do
        %w[
          abcde
          abc_def
          abc-
          -abc
          ab--cd
          -abc-
        ].each do |value|
          it "is invalid with invalid fomat with #{value}" do
            team = build(:team, permalink: value)
            expect(team).to be_invalid
            expect(team.errors[:permalink]).to include("は英小文字・数字とハイフンで構成し、ハイフンで区切られている必要があります（連続ハイフン不可）")
          end
        end
      end

      context 'length' do
        it "is invalid with less than 5 length" do
          team = build(:team, permalink: 'ab-c')
          expect(team).to be_invalid
          expect(team.errors[:permalink]).to include("は5文字以上で入力してください")
        end

        it "is invalid with longer than 32 length" do
          team = build(:team, permalink: 'aaaaa-bbbbb-ccccc-ddddd-eeeee-fff')
          expect(team).to be_invalid
          expect(team.errors[:permalink]).to include("は32文字以内で入力してください")
        end
      end

      context 'uniqueness' do
        it "is invalid with same permalink" do
          build(:team, permalink: 'same-permalink').save!
          team = build(:team, permalink: 'same-permalink')
          expect(team).to be_invalid
          expect(team.errors[:permalink]).to include("はすでに存在します")
        end
      end
    end
  end

  describe 'image attachment' do
    it "purges the image when team is destroyed" do
      team = create(:team)
      team.image.attach(
        io: File.open(Rails.root.join("spec/fixtures/image/sample.png")),
        filename: "sample.png",
        content_type: "image/png"
      )

      expect(team.image).to be_attached

      expect {
        team.destroy
      }.to change(ActiveStorage::Attachment, :count).by(-1)
    end
  end
end

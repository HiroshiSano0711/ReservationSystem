require "rails_helper"

RSpec.describe Admin::StaffProfilesController, type: :request do
  include_context "admin access setup"

  describe 'admin access' do
    let(:staff) { create(:staff, team: team) }
    let(:staff_profile) { create(:staff_profile, staff: staff) }

    it "inherits from Admin::BaseController" do
      expect(described_class < Admin::BaseController).to be true
    end

    it_behaves_like "admin-only access" do
      let(:path) { edit_admin_staff_profile_path(staff_id: staff_profile.staff.id) }
    end
  end

  describe 'action' do
    let(:staff) { create(:staff, team: team) }
    let(:staff_profile) { create(:staff_profile, staff: staff) }
    let(:service_menus) { create_list(:service_menu, 3, team: team) }
    let(:staff_profile_form_params) do
      {
        image: Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'image', 'sample.png'), 'image/png'),
        working_status: 'active',
        nick_name: 'Ruby Man',
        accepts_direct_booking: true,
        bio: 'A dedicated staff member.',
        selected_service_menu_ids: service_menus.map(&:id)
      }
    end

    before do
      sign_in admin, scope: :staff
    end

    describe 'GET #edit' do
      it 'スタッフのプロフィール編集ページが表示される' do
        get edit_admin_staff_profile_path(staff_id: staff_profile.staff.id)

        expect(response).to have_http_status(:success)
      end
    end

    describe 'PATCH #update' do
      context '有効なパラメータの場合' do
        it 'スタッフプロフィールが更新され、リダイレクトされる' do
          patch admin_staff_profile_path(team_id: team.id, staff_id: staff_profile.staff.id), params: { staff_profile_form: staff_profile_form_params }

          staff.reload
          expect(staff.staff_profile.working_status).to eq('active')
          expect(staff.staff_profile.nick_name).to eq('Ruby Man')
          expect(staff.staff_profile.bio).to eq('A dedicated staff member.')
          expect(response).to redirect_to(admin_staffs_path)
          expect(flash[:notice]).to be_present
        end
      end

      context '無効なパラメータの場合' do
        it 'スタッフプロフィールの更新に失敗し、エラーメッセージが表示される' do
          invalid_params = { staff_profile_form: { working_status: '', nick_name: '' } }

          patch admin_staff_profile_path(team_id: team.id, staff_id: staff_profile.staff.id), params: invalid_params

          staff.reload
          expect(staff.staff_profile.working_status).to_not eq('')
          expect(staff.staff_profile.nick_name).to_not eq('')
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to render_template(:edit)
          expect(flash[:alert]).to be_present
        end
      end
    end
  end
end

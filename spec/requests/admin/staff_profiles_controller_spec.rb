require "rails_helper"

RSpec.describe Admin::StaffProfilesController, type: :request do
  include_context "admin access setup"

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
      get edit_admin_staff_profile_path(team_id: team.id, staff_id: staff_profile.staff.id)
      expect(response).to have_http_status(:success)
      expect(response.body).to include('スタッフプロフィールの編集')
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
        follow_redirect!
        expect(response.body).to include('スタッフのプロフィール情報を更新しました。')
      end
    end

    context '無効なパラメータの場合' do
      it 'スタッフプロフィールの更新に失敗し、エラーメッセージが表示される' do
        invalid_params = { staff_profile_form: { working_status: '', nick_name: '' } }

        patch admin_staff_profile_path(team_id: team.id, staff_id: staff_profile.staff.id), params: invalid_params

        staff.reload
        expect(staff.staff_profile.working_status).to_not eq('')
        expect(staff.staff_profile.nick_name).to_not eq('')

        expect(response).to render_template(:edit)
        expect(response.body).to include('更新に失敗しました。入力内容を確認してください。')
      end
    end
  end
end

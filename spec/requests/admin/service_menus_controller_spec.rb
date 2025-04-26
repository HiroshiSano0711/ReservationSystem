require "rails_helper"

RSpec.describe Admin::ServiceMenusController, type: :request do
  include_context "admin access setup"

  describe "admin access" do
    it "inherits from Admin::BaseController" do
      expect(described_class < Admin::BaseController).to be true
    end

    it_behaves_like "admin-only access" do
      let(:path) { admin_service_menus_path }
    end

    it_behaves_like "admin-only access" do
      let(:path) { new_admin_service_menu_path }
    end

    it_behaves_like "admin-only access" do
      let(:path) { edit_admin_service_menu_path(create(:service_menu, team: team)) }
    end
  end

  describe "action" do
    before do
      sign_in admin, scope: :staff
    end

    describe "GET #index" do
      it "サービスメニュー一覧が表示される" do
        get admin_service_menus_path

        expect(response).to have_http_status(:success)
      end
    end

    describe "GET #new" do
      it "新しいサービスメニューの作成ページが表示される" do
        get new_admin_service_menu_path

        expect(response).to have_http_status(:success)
      end
    end

    describe "POST #create" do
      context "有効なパラメータの場合" do
        it "新しいサービスメニューが作成され、リダイレクトされる" do
          expect {
            post admin_service_menus_path, params: { service_menu: attributes_for(:service_menu) }
          }.to change(ServiceMenu, :count).by(1)

          expect(response).to redirect_to(admin_service_menus_path)
          expect(flash[:notice]).to be_present
        end
      end

      context "無効なパラメータの場合" do
        it "サービスメニューの作成に失敗し、エラーメッセージが表示される" do
          invalid_params = { service_menu: { name: "", price: -1 } }

          expect {
            post admin_service_menus_path, params: invalid_params
          }.to_not change(ServiceMenu, :count)

          expect(response).to render_template(:new)
          expect(flash[:alert]).to be_present
        end
      end
    end

    describe "GET #edit" do
      let!(:service_menu) { create(:service_menu, team: team) }

      it "サービスメニューの編集ページが表示される" do
        get edit_admin_service_menu_path(id: service_menu.id)

        expect(response).to have_http_status(:success)
      end
    end

    describe "PATCH #update" do
      let!(:service_menu) { create(:service_menu, team: team) }

      context "有効なパラメータの場合" do
        it "サービスメニューが更新され、リダイレクトされる" do
          updated_params = { service_menu: { name: "Updated Menu", price: 1000 } }

          patch admin_service_menu_path(id: service_menu.id), params: updated_params
          service_menu.reload

          expect(service_menu.name).to eq("Updated Menu")
          expect(service_menu.price).to eq(1000)
          expect(response).to redirect_to(admin_service_menus_path)
          expect(flash[:notice]).to be_present
        end
      end

      context "無効なパラメータの場合" do
        it "サービスメニューの更新に失敗し、エラーメッセージが表示される" do
          invalid_params = { service_menu: { name: "", price: -1 } }

          patch admin_service_menu_path(id: service_menu.id), params: invalid_params
          service_menu.reload

          expect(service_menu.name).to_not eq("")
          expect(service_menu.price).to_not eq(-1)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to render_template(:edit)
          expect(flash[:alert]).to be_present
        end
      end
    end
  end
end

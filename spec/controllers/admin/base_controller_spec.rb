require 'rails_helper'

RSpec.describe Admin::BaseController, type: :controller do
  let(:admin) { create(:staff, role: :admin_staff, invitation_accepted_at: FIXED_TIME.call) }
  let(:non_admin) { create(:staff, role: :general, invitation_accepted_at: FIXED_TIME.call) }
  let(:not_accept_admin_staff) { create(:staff, role: :admin_staff, invitation_accepted_at: nil) }
  let(:customer) { create(:customer) }

  controller(Admin::BaseController) do
    def index
      render plain: "success"
    end
  end

  describe "GET #index" do
    context "when staff is admin" do
      before { sign_in admin, scope: :staff }

      it "allows access" do
        get :index
        expect(response.body).to eq("success")
      end
    end

    context "when staff is not admin" do
      before { sign_in non_admin, scope: :staff }

      it "redirects to root path with alert" do
        get :index
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("管理者権限がありません。")
      end
    end

    context "when staff is not accepted invitation" do
      before { sign_in not_accept_admin_staff, scope: :staff }

      it "redirects to new session path with alert" do
        get :index
        expect(response).to redirect_to(new_staff_session_path)
        expect(flash[:alert]).to eq("招待を承認してからログインしてください。")
      end
    end

    context "when customer" do
      before { sign_in customer, scope: :customer }

      it "redirects to new session path with alert" do
        get :index
        expect(response).to redirect_to(new_staff_session_path)
      end
    end
  end
end

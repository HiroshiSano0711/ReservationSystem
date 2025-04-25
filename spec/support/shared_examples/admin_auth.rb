RSpec.shared_examples "admin-only access" do
  context "when staff is admin" do
    before { sign_in admin, scope: :staff }
    it "allows access" do
      get path
      expect(response).to have_http_status(:ok)
    end
  end

  context "when staff is not admin" do
    before { sign_in non_admin, scope: :staff }
    it "redirects to root" do
      get path
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("管理者権限がありません。")
    end
  end

  context "when invitation is not accepted" do
    before { sign_in not_accept_admin_staff, scope: :staff }
    it "redirects to login" do
      get path
      expect(response).to redirect_to(new_staff_session_path)
      expect(flash[:alert]).to eq("招待を承認してからログインしてください。")
    end
  end

  context "when customer" do
    before { sign_in customer, scope: :customer }
    it "redirects to login" do
      get path
      expect(response).to redirect_to(new_staff_session_path)
    end
  end
end

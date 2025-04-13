class ApplicationController < ActionController::Base
  # allow_browser versions: :modern

  def after_sign_in_path_for(resource)
    if resource.class == Customer
      mypage_reservations_path
    elsif resource.admin_staff?
      admin_path
    end
  end
end

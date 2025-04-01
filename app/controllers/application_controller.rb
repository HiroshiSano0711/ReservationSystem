class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  def after_sign_in_path_for(resource)
    if resource.admin_staff?
      admin_root_path
    else
      customer_root_path
    end
  end
end

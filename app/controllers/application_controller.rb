class ApplicationController < ActionController::Base
  def after_sign_up_path_for(resource)
    after_sign_in_path_for(resource) if is_navigational_format?
  end

  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_root_path
    else
      client_root_path
    end
  end
end

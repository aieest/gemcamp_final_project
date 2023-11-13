# frozen_string_literal: true

class Client::Users::RegistrationsController < Devise::RegistrationsController
  def new
    super

    if params[:promoter].present?
      cookies[:promoter] = params[:promoter]
    end
  end

  def create
    super do |resource|
      if (promoter_email = cookies.delete(:promoter)).present?
        promoter = User.find_by(email: promoter_email)
        resource.parent = promoter if promoter
        resource.save
      end
    end
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :parent_id])
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:phone, :username, :image])
  end

end

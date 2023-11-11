# frozen_string_literal: true

class Client::Users::RegistrationsController < Devise::RegistrationsController

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:phone, :username, :image])
  end
end

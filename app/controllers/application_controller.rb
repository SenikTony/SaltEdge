class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :gateway_user!, unless: :devise_controller?

  private 

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def gateway_user!
    return if controller_name == "user_profiles"

    redirect_to user_profiles_path unless current_user.gateway_user?
  end
end

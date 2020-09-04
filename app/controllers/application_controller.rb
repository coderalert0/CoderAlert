class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # rubocop:disable Metrics/MethodLength
  def configure_permitted_parameters
    # rubocop:enable Metrics/MethodLength
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:first_name,
               :last_name,
               :email,
               :password)
    end

    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:first_name,
               :last_name,
               :email,
               :password,
               :current_password)
    end
  end
end

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_permitted_parameters

    # GET /resource/sign_up
    def new
      build_resource({})
      resource.build_company
      respond_with resource
    end

    protected

    # rubocop:disable Metrics/MethodLength
    def configure_permitted_parameters
      # rubocop:enable Metrics/MethodLength
      devise_parameter_sanitizer.permit(:sign_up) do |u|
        u.permit(:first_name,
                 :last_name,
                 :email,
                 :password,
                 company_attributes: :name)
      end

      devise_parameter_sanitizer.permit(:account_update) do |u|
        u.permit(:first_name,
                 :last_name,
                 :email,
                 :password,
                 :current_password,
                 company_attributes: :name)
      end
    end
  end
end

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
                 :profile_image,
                 company_attributes: :name)
      end
    end

    def after_inactive_sign_up_path_for(_user)
      flash.notice = 'We have sent an email with a confirmation link to your email address.'\
                     'Please click the confirmation link. If you do not see the invitation email in your inbox, '\
                     'please look in the spam folder and mark it as not spam'

      new_user_session_path
    end
  end
end

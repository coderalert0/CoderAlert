module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_permitted_parameters

    # GET /resource/sign_up
    def new
      build_resource({})
      resource.build_company
      respond_with resource
    end

    def create
      super do
        resource.build_contact_email(value: resource.email)
        resource.save!
      end
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
                 :password_confirmation,
                 :global_admin,
                 :time_zone,
                 :pto,
                 :title,
                 company_attributes: :name).merge(global_admin: true)
      end

      devise_parameter_sanitizer.permit(:account_update) do |u|
        u.permit(:first_name,
                 :last_name,
                 :email,
                 :password,
                 :password_confirmation,
                 :current_password,
                 :profile_image,
                 :time_zone,
                 :pto,
                 :title,
                 company_attributes: :name)
      end
    end

    def update_resource(resource, params)
      resource.update_without_password(params)
    rescue StandardError
      flash.alert = resource.errors.full_messages
    end

    def after_inactive_sign_up_path_for(_user)
      flash.notice = t('devise.registrations.confirmation_instructions')

      new_user_session_path
    end
  end
end

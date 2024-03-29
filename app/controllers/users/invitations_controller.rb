module Users
  class InvitationsController < Devise::InvitationsController
    include DeviseConcern

    before_action :configure_permitted_parameters, only: :update

    def new
      @projects = current_user.company.projects
      authorize_project_user(@projects)

      @form = InviteUserForm.new
      super
    end

    def create
      @form = create_form
      authorize_project_user(@form.projects)

      if @form.submit
        flash.notice = t(:create, first_name: @form.first_name,
                                  last_name: @form.last_name,
                                  scope: %i[invite_a_team_member flash])
        redirect_to submit_redirect_path
      else
        flash.alert = @form.display_errors
        redirect_to action: :new
      end
    end

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:accept_invitation,
                                        keys: %i[password password_confirmation invitation_token time_zone])
    end

    private

    def after_accept_path_for(user)
      devise_after_path(user)
    end

    def create_form
      InviteUserForm.new form_params.merge(company: current_user.company)
    end

    def form_params
      form_params = params.require(:invite_user_form).permit(InviteUserForm.accessible_attributes)
      form_params[:project_ids].reject! { |project_id| project_id if project_id == '' }
      form_params
    end

    def submit_redirect_path
      button_clicked = params[:commit]

      case button_clicked
      when 'Submit'
        project_project_users_path(@current_project)
      when 'Submit & Invite More'
        new_user_invitation_path
      end
    end

    def authorize_project_user(projects)
      projects.each { |project| authorize! :crud, ProjectUser.new(project: project) }
    end
  end
end

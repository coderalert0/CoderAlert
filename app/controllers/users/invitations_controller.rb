module Users
  class InvitationsController < Devise::InvitationsController
    include DeviseConcern

    def new
      @form = InviteUserForm.new
      @projects = current_user.company.projects
      super
    end

    def create
      @form = create_form

      if @form.submit
        flash.notice = 'The user was invited to the project(s) successfully'
        redirect_to project_project_users_path(@project)
      else
        flash.alert = @form.display_errors
        redirect_to action: :new
      end
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
  end
end

module Users
  class InvitationsController < Devise::InvitationsController
    def new
      @form = InviteUserForm.new
      @projects = current_user.company.projects
      super
    end

    def create
      @form = InviteUserForm.new form_params.merge(company: current_user.company)
      redirect_to project_users_path(Project.last) if @form.submit
    end

    private

    def form_params
      form_params = params.require(:invite_user_form).permit(InviteUserForm.accessible_attributes)
      form_params[:project_ids].reject! { |project_id| project_id if project_id == '' }
      form_params
    end
  end
end

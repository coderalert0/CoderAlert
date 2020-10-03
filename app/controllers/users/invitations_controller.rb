module Users
  class InvitationsController < Devise::InvitationsController
    include InviteUsersConcern

    def new
      @form = InviteUserForm.new
      @projects = current_user.company.projects
      super
    end

    def create
      @form = invite_users_create_form
      if @form.submit
        flash.notice = 'The user was invited to the project(s) successfully'
        redirect_to project_users_path
      else
        flash.alert = @form.display_errors
        redirect_to action: :new
      end
    end

    private

    def after_accept_path_for(user)
      session[:project_id] = if user.last_accessed_project.present?
                               user.last_accessed_project.id
                             elsif user.projects.present?
                               user.projects.last.id
                             end

      session[:project_id].present? ? root_path : after_signup_path(:create_project)
    end
  end
end

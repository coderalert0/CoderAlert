module Users
  class InvitationsController < Devise::InvitationsController
    include InviteUsersConcern
    include DeviseConcern

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
      devise_after_path(user)
    end
  end
end

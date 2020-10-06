module Wizard
  class UsersStep < BaseStep
    attr_accessor :company, :project

    def show_form
      InviteUserForm.new post_params
    end

    def update_form
      InviteUserForm.new post_params
        .require(:invite_user_form)
        .permit(InviteUserForm.accessible_attributes)
        .merge(company: company, project_ids: [project.id.to_s])
    end
  end
end

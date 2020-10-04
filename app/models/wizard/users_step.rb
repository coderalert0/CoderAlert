module Wizard
  class UsersStep < BaseStep
    attr_accessor :company

    def show_form
      InviteUserForm.new post_params
    end

    def update_form
      InviteUserForm.new filter_post_params.merge(company: company)
    end

    def filter_post_params
      form_params = post_params.require(:invite_user_form).permit(InviteUserForm.accessible_attributes)
      form_params[:project_ids].reject! { |project_id| project_id if project_id == '' }
      form_params
    end
  end
end

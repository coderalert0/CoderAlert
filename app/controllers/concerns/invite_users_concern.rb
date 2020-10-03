module InviteUsersConcern
  extend ActiveSupport::Concern

  def invite_users_create_form
    InviteUserForm.new invite_users_form_params.merge(company: current_user.company)
  end

  private

  def invite_users_form_params
    form_params = params.require(:invite_user_form).permit(InviteUserForm.accessible_attributes)
    form_params[:project_ids].reject! { |project_id| project_id if project_id == '' }
    form_params
  end
end

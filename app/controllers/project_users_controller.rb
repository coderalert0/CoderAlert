class ProjectUsersController < ApplicationController
  load_and_authorize_resource
  load_and_authorize_resource :project

  def index
    @project_users = ProjectUser.where(project: @project).decorate
  end

  def new
    @form = PermissionUserForm.new
    @users = User.unpermissioned_to_project(@project).decorate

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @form = PermissionUserForm.new form_params.merge(project: @project)
    redirect_to project_users_path(@project) if @form.submit
  end

  def destroy
    redirect_to project_users_path(@project) if @project_user.destroy
  end

  private

  def form_params
    params.require(:permission_user_form).permit(PermissionUserForm.accessible_attributes)
  end
end

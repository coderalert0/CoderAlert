class ProjectUsersController < ApplicationController
  load_and_authorize_resource
  before_action :load_and_authorize_project

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
    if @form.submit
      flash.notice = 'The user was permissioned to the project successfully'
      redirect_to project_users_path(@project)
    else
      flash.alert = @form.display_errors
      render :new
    end
  end

  def destroy
    if @project_user.destroy
      flash.notice = 'The user was unpermissioned from the project successfully'
      redirect_to project_users_path(@project)
    else
      flash.alert = 'The user could not be unpermissioned from the project'
      render :index
    end
  end

  private

  def form_params
    params.require(:permission_user_form).permit(PermissionUserForm.accessible_attributes)
  end

  def load_and_authorize_project
    # need to authorize
    @project = Project.friendly.find(params[:project_id])
  end
end

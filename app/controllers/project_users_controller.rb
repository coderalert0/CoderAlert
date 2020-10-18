class ProjectUsersController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource through: :project

  def index
    @project_users = ProjectUser.where(project: @project).page(params[:page]).decorate
  end

  def new
    @form = PermissionUserForm.new(project: @project)
    @users = User.unpermissioned_to_project(@project).decorate

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @form = create_form
    authorize! :permission, @project_user

    if @form.submit
      flash.notice = 'The user was permissioned to the project successfully'
      redirect_to project_project_users_path(@project)
    else
      flash.alert = @form.display_errors
      render :new
    end
  end

  def edit
    @form = PermissionUserForm.new project_user: @project_user

    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @form = edit_form

    if @form.submit
      flash.notice = 'The user permission was edited successfully'
      redirect_to project_project_users_path(@project)
    else
      flash.alert = @form.display_errors
    end
  end

  def destroy
    if @project_user.destroy
      flash.notice = 'The user was unpermissioned from the project successfully'
      redirect_to project_project_users_path(@project)
    else
      flash.alert = 'The user could not be unpermissioned from the project'
      render :index
    end
  end

  private

  def form_params
    params.require(:permission_user_form).permit(PermissionUserForm.accessible_attributes)
  end

  def create_form
    PermissionUserForm.new form_params.merge(project_user: @project_user)
  end

  def edit_form
    EditPermissionUserForm.new form_params.merge(project_user: @project_user)
  end
end

class UsersController < ApplicationController
  load_and_authorize_resource :project

  def index
    @users = @project.users.decorate
  end

  def new
    @form = PermissionUserForm.new
    @users = User.unpermissioned_to_project(@project).decorate

    respond_to do |format|
      format.html
      format.js
    end
  end
end

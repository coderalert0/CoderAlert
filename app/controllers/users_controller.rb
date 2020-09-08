class UsersController < ApplicationController
  load_and_authorize_resource :project

  def index
    @users = @project.users.decorate
  end
end

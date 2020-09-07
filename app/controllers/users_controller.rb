class UsersController < ApplicationController
  load_and_authorize_resource :project

  def index
    @users = @project.users
  end
end

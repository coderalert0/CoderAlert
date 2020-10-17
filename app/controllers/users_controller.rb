class UsersController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource

  def show
    @user = @user.decorate
  end
end

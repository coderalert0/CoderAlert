class ActiveProjectController < ApplicationController
  include ProjectConcern

  def update
    id = params[:id]

    @project = Project.find(id.to_i)
    authorize! :read, @project

    switch_active_project

    flash.notice = t(:update, scope: %i[active_project flash])
    redirect_to root_path
  end
end

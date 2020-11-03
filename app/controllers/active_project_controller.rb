class ActiveProjectController < ApplicationController
  def update
    id = params[:id]

    @project = Project.find(id.to_i)
    authorize! :read, @project

    switch_active_project

    flash.notice = t(:update, scope: %i[active_project flash])
    redirect_to root_path
  end

  private

  def switch_active_project
    session[:project_id] = @project.id
    current_user.update(last_accessed_project: @project)
  end
end

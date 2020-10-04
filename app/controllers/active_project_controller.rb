class ActiveProjectController < ApplicationController
  def update
    id = params[:id]

    return if id.blank? && current_user.projects.map { |p| p.id.to_s }.exclude?(id)

    id = id.to_i
    session[:project_id] = id
    current_user.update(last_accessed_project_id: id)

    flash.notice = 'Project switched successfully'
    redirect_to root_path
  end
end

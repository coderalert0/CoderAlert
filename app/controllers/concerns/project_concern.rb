module ProjectConcern
  extend ActiveSupport::Concern

  def switch_active_project
    session[:project_id] = @project.id
    current_user.update(last_accessed_project: @project)
  end
end

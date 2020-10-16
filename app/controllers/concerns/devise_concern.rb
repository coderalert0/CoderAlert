module DeviseConcern
  extend ActiveSupport::Concern

  def devise_after_path(user)
    if user.last_accessed_project.present?
      session[:project_id] = user.last_accessed_project.id

    elsif user.projects.present?
      last_project_permissioned_to = user.projects.last
      user.update(last_accessed_project: last_project_permissioned_to)
      session[:project_id] = last_project_permissioned_to.id
    end

    if session[:project_id].present?
      stored_location_for(user) || root_path
    else
      after_signup_path(:project)
    end
  end
end

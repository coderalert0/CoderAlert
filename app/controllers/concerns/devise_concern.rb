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

    session[:project_id].present? ? root_path : after_signup_path(:create_project)
  end
end

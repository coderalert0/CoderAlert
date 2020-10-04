module DeviseConcern
  extend ActiveSupport::Concern

  def devise_after_path(user)
    session[:project_id] = if user.last_accessed_project.present?
                             user.last_accessed_project.id
                           elsif user.projects.present?
                             user.projects.last.id
                           end

    session[:project_id].present? ? root_path : after_signup_path(:create_project)
  end
end
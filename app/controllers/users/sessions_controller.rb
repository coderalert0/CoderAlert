module Users
  class SessionsController < Devise::SessionsController
    private

    def after_sign_in_path_for(user)
      session[:project_id] = if user.last_accessed_project.present?
                               user.last_accessed_project.id
                             elsif user.projects.present?
                               user.projects.last.id
                             end

      session[:project_id].present? ? root_path : after_signup_path(:create_project)
    end
  end
end

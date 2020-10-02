module Users
  class SessionsController < Devise::SessionsController
    skip_before_action :load_context

    def create
      super do |user|
        # need to update logic for user without any projects,
        # should happen in the case a user is the first signup in the company

        if user.persisted?
          session[:project_id] = if user.last_accessed_project.nil?
                                   user.projects.last.id
                                 else
                                   user.last_accessed_project.id
                                 end
        end
      end
    end
  end
end

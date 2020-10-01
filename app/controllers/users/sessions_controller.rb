module Users
  class SessionsController < Devise::SessionsController
    def create
      super do |user|
        # need to update logic for user without any projects,
        # should happen in the case a user is the first signup in the company

        session[:project_id] = user.current_project.try(:id) if user.persisted?
      end
    end
  end
end

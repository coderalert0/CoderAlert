module Users
  class SessionsController < Devise::SessionsController
    def create
      super do |user|
        session[:project_id] = Project.last.id if user.persisted?
      end
    end
  end
end

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_paper_trail_whodunnit
  before_action :authenticate_user!
  before_action :load_projects

  def load_projects
    return if current_user.nil? || session[:project_id].nil?

    @current_project = Project.find(session[:project_id])
    @projects = current_user.projects
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render nothing: true, status: :not_found }
      format.html { redirect_back fallback_location: root_path, alert: exception.message }
      format.js   { render nothing: true, status: :not_found }
    end
  end
end

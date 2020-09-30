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
end

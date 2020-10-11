class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  around_action :current_user_tag

  before_action :set_paper_trail_whodunnit
  before_action :authenticate_user!
  before_action :load_context

  private

  def current_user_tag(&block)
    logger.tagged("USER_ID: #{current_user.try(:id)}", &block)
  end

  def load_context
    return if current_user.nil?
    redirect_to after_signup_path(:project) and return if session[:project_id].nil?

    @current_project = Project.find(session[:project_id]).decorate
    @projects = current_user.projects.decorate
  end

  def form_params(clazz)
    params.require(clazz.to_s.snakify.to_sym).permit(clazz.accessible_attributes)
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render nothing: true, status: :not_found }
      format.html { redirect_back fallback_location: root_path, alert: exception.message }
      format.js   { render nothing: true, status: :not_found }
    end
  end
end

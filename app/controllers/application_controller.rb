class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # around_action :current_user_tag
  # around_action :user_time_zone_setter, if: :current_user

  before_action :set_paper_trail_whodunnit
  before_action :authenticate_user!
  before_action :load_context

  def browser_time_zone
    browser_tz = ActiveSupport::TimeZone.find_tzinfo(cookies['browser.timezone'])
    ActiveSupport::TimeZone.all.find { |zone| zone.tzinfo == browser_tz } || Time.zone
  rescue TZInfo::UnknownTimezone, TZInfo::InvalidTimezoneIdentifier
    Time.zone
  end
  helper_method :browser_time_zone

  private

  def user_time_zone_setter(&block)
    Time.use_zone(current_user.time_zone, &block)
  end

  def current_user_tag(&block)
    logger.tagged("USER_ID: #{current_user.try(:id)}", &block)
  end

  def load_context
    return if current_user.nil?

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

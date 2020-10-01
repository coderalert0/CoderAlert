class ActiveProjectController < ApplicationController
  def update
    id = params[:id]

    return if id.blank? && current_user.projects.map { |p| p.id.to_s }.exclude?(id)

    session[:project_id] = id.to_i
    redirect_back(fallback_location: root_path)
  end
end

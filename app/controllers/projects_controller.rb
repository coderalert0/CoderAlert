class ProjectsController < ApplicationController
  load_and_authorize_resource :project

  def index
    @projects = current_user.projects
  end

  def show
    @tickets = @project.tickets
  end

  def new
    @form = CreateProjectForm.new
  end

  def create
    @form = CreateProjectForm.new form_params.merge(company: current_user.company)
    redirect_to root_path if @form.submit
  end

  private

  def form_params
    params.require(:create_project_form).permit(CreateProjectForm.accessible_attributes)
  end
end

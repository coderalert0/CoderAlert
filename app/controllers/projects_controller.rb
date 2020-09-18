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
    if @form.submit
      flash.notice = 'The project was created successfully'
      redirect_to projects_path
    end
  end

  private

  def form_params
    params.require(:create_project_form).permit(CreateProjectForm.accessible_attributes)
  end
end

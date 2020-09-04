class ProjectsController < ApplicationController
  def index
    # update this to only show projects for a particular company
    @projects = Project.all
  end

  def new
    @form = CreateProjectForm.new
  end

  def create
    @form = CreateProjectForm.new form_params
    redirect_to root_path if @form.submit
  end

  private

  def form_params
    params.require(:create_project_form).permit(CreateProjectForm.accessible_attributes)
  end
end

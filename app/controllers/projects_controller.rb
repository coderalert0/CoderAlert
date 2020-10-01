class ProjectsController < ApplicationController
  before_action :load_project, only: %i[show edit destroy]
  load_and_authorize_resource only: %i[index new create]

  def index; end

  def show
    authorize! :read, @project

    @tickets = @project.tickets
  end

  def new
    @form = CreateProjectForm.new
  end

  def create
    @form = CreateProjectForm.new form_params.merge(user: current_user)

    if @form.submit
      flash.notice = 'The project was created successfully'
      redirect_to projects_path
    else
      flash.alert = @form.display_errors
      render :new
    end
  end

  def destroy
    authorize! :destroy, @project

    if @project.destroy
      flash.notice = 'The project was deleted successfully'
      redirect_to projects_path
    else
      flash.alert = 'The project could not be deleted'
      render :show
    end
  end

  private

  def form_params
    params.require(:create_project_form).permit(CreateProjectForm.accessible_attributes)
  end

  def load_project
    @project = Project.friendly.find(params[:id])
  end
end

class ProjectsController < ApplicationController
  load_and_authorize_resource

  def index; end

  def show; end

  def edit
    @form = EditProjectForm.new project: @project
  end

  def update
    @form = edit_form

    if @form.submit
      flash.notice = 'The project was edited successfully'
      redirect_to projects_path
    else
      flash.alert = @form.display_errors
      render :edit
    end
  end

  def new
    @form = CreateProjectForm.new
  end

  def create
    @form = create_form

    if @form.submit
      flash.notice = 'The project was created successfully'
      redirect_to projects_path
    else
      flash.alert = @form.display_errors
      render :new
    end
  end

  def destroy
    if @project.destroy
      flash.notice = 'The project was deleted successfully'
      redirect_to projects_path
    else
      flash.alert = 'The project could not be deleted'
      render :show
    end
  end

  private

  def create_form
    CreateProjectForm.new form_params(CreateProjectForm)
      .merge(project: @project, company: current_user.company)
  end

  def edit_form
    EditProjectForm.new form_params(EditProjectForm)
      .merge(project: @project, company: current_user.company)
  end
end

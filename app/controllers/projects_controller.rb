class ProjectsController < ApplicationController
  load_and_authorize_resource

  def index; end

  def show; end

  def new
    @form = CreateProjectForm.new
  end

  def create
    @form = create_form

    if @form.submit
      flash.notice = t(:create, scope: %i[project flash])
      redirect_to projects_path
    else
      flash.alert = @form.display_errors
      render :new
    end
  end

  def edit
    @form = EditProjectForm.new project: @project
  end

  def update
    @form = edit_form

    if @form.submit
      flash.notice = t(:update, scope: %i[project flash])
      redirect_to projects_path
    else
      flash.alert = @form.display_errors
      render :edit
    end
  end

  def destroy
    if @project.destroy
      flash.notice = t(:destroy, scope: %i[project flash])
      redirect_to projects_path
    else
      flash.alert = t(:destroy_error, scope: %i[project flash])
      render :show
    end
  end

  private

  def create_form
    CreateProjectForm.new form_params(CreateProjectForm)
      .merge(project: @project, company: current_user.company, user: current_user)
  end

  def edit_form
    EditProjectForm.new form_params(EditProjectForm)
      .merge(project: @project, company: current_user.company)
  end
end

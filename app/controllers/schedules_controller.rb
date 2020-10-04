class SchedulesController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource through: :project

  def index
    @schedules = @current_project.schedules
  end

  def show; end

  def new
    @form = CreateScheduleForm.new
  end

  def create
    @form = create_form

    if @form.submit
      flash.notice = 'The schedule was created successfully'
      redirect_to project_schedules_path
    else
      flash.alert = @form.display_errors
      render :new
    end
  end

  def edit
    @form = EditScheduleForm.new schedule: @schedule
  end

  def update
    @form = edit_form

    if @form.submit
      flash.notice = 'The schedule was edited successfully'
      redirect_to project_schedules_path
    else
      flash.alert = @form.display_errors
      render :edit
    end
  end

  def destroy
    if @schedule.destroy
      flash.notice = 'The schedule was deleted successfully'
      redirect_to project_schedules_path
    else
      flash.alert = 'The schedule could not be deleted'
      render :show
    end
  end

  private

  def create_form
    CreateScheduleForm.new form_params(CreateScheduleForm).merge(schedule: @schedule)
  end

  def edit_form
    EditScheduleForm.new form_params(EditScheduleForm).merge(schedule: @schedule)
  end
end

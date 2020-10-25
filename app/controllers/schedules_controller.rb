class SchedulesController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource through: :project

  before_action :load_time_zone, only: %i[new edit]

  def index
    @schedules = @current_project.schedules
  end

  def show
    gon.url = project_schedule_path(@project, @schedule, format: :json)
  end

  def new
    @form = CreateScheduleForm.new
  end

  def create
    @form = create_form

    if @form.submit
      flash.notice = 'The schedule was created successfully'
      redirect_to project_schedule_path(@project, @schedule)
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
      redirect_to project_schedule_path(@project, @schedule)
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
    CreateScheduleForm.new form_params(CreateScheduleForm).merge(schedule: @schedule, user: current_user)
  end

  def edit_form
    EditScheduleForm.new form_params(EditScheduleForm).merge(schedule: @schedule)
  end

  def load_time_zone
    gon.time_zone = ActiveSupport::TimeZone::MAPPING[current_user.time_zone].to_s
  end
end

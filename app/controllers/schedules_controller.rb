class SchedulesController < ApplicationController
  load_and_authorize_resource only: %i[show destroy]

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
      redirect_to schedules_path
    else
      flash.alert = @form.display_errors
      render :new
    end
  end

  def destroy
    if @schedule.destroy
      flash.notice = 'The schedule was deleted successfully'
      redirect_to schedules_path
    else
      flash.alert = 'The schedule could not be deleted'
      render :show
    end
  end

  private

  def create_form
    @schedule = Schedule.new(user: current_user, project: @current_project)
    authorize! :create, @schedule
    CreateScheduleForm.new form_params.merge(schedule: @schedule)
  end

  def form_params
    params.require(:create_schedule_form).permit(CreateScheduleForm.accessible_attributes)
  end
end

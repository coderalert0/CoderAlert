class SchedulesController < ApplicationController
  before_action :load_and_authorize_project
  load_and_authorize_resource

  def index
    @schedules = @project.schedules
  end

  def show; end

  def new
    @form = CreateScheduleForm.new
  end

  def create
    @form = CreateScheduleForm.new form_params.merge(project: @project)
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

  def form_params
    params.require(:create_schedule_form).permit(CreateScheduleForm.accessible_attributes)
  end

  def load_and_authorize_project
    # need to authorize
    @project = Project.friendly.find(session[:project_id])
  end
end

class SchedulesController < ApplicationController
  load_and_authorize_resource :project
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
    redirect_to project_schedules_path(@project) if @form.submit
  end

  def destroy
    redirect_to project_schedules_path(Project.last) if @schedule.destroy
  end

  private

  def form_params
    params.require(:create_schedule_form).permit(CreateScheduleForm.accessible_attributes)
  end
end

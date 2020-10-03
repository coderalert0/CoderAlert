module ScheduleConcern
  extend ActiveSupport::Concern

  def schedule_create_form
    initialize_and_authorize_schedule
    CreateScheduleForm.new schedule_form_params.merge(schedule: @schedule)
  end

  private

  def initialize_and_authorize_schedule
    @schedule = Schedule.new(user: current_user, project: @current_project)
    authorize! :create, @schedule
  end

  def schedule_form_params
    params.require(:create_schedule_form).permit(CreateScheduleForm.accessible_attributes)
  end
end

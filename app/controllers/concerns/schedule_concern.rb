module ScheduleConcern
  extend ActiveSupport::Concern

  def schedule_create_form
    initialize_and_authorize_schedule
    CreateScheduleForm.new create_schedule_form_params.merge(schedule: @schedule)
  end

  def schedule_edit_form(schedule)
    EditScheduleForm.new edit_schedule_form_params.merge(schedule: schedule)
  end

  private

  def initialize_and_authorize_schedule
    @schedule = Schedule.new(user: current_user, project: @current_project)
    authorize! :create, @schedule
  end

  def create_schedule_form_params
    params.require(:create_schedule_form).permit(CreateScheduleForm.accessible_attributes)
  end

  def edit_schedule_form_params
    params.require(:edit_schedule_form).permit(EditScheduleForm.accessible_attributes)
  end
end

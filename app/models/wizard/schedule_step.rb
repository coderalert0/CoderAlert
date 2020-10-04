module Wizard
  class ScheduleStep < BaseStep
    attr_accessor :schedule

    def show_form
      CreateScheduleForm.new(schedule: schedule)
    end

    def update_form
      CreateScheduleForm.new post_params.require(:create_schedule_form)
                                        .permit(CreateScheduleForm.accessible_attributes)
                                        .merge(schedule: schedule)
    end

    def complete
      self.schedule = update_form.schedule
      super
    end
  end
end

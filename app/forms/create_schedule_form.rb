class CreateScheduleForm < BaseForm
  include ActiveRecord::AttributeAssignment

  attr_accessor :name, :frequency, :start, :end, :user, :project
  attr_writer :schedule

  nested_attributes :name, :frequency, :start, :end, :user, :project, to: :schedule

  accessible_attr :name, :frequency, :start, :end

  def schedule
    @schedule ||= Schedule.new
  end

  def _submit
    schedule.save!
  end
end

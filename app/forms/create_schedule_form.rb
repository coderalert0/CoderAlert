class CreateScheduleForm < BaseForm
  include ActiveRecord::AttributeAssignment

  attr_accessor :users

  attr_writer :schedule

  nested_attributes :name, :frequency, :start, :end, :user, :project, to: :schedule

  accessible_attr :name, :frequency, :start, :end, users: {}

  def schedule
    @schedule ||= Schedule.new
  end

  def _submit
    ActiveRecord::Base.transaction do
      schedule.save!

      users.each do |user_id, priority|
        ScheduleUser.create(user_id: user_id, schedule: schedule, priority: priority)
      end
    end
  end
end

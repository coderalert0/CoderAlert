class CreateScheduleForm < BaseForm
  include ActiveRecord::AttributeAssignment

  attr_accessor :users, :success

  attr_writer :schedule

  nested_attributes :name, :frequency, :start, :end, :project, :user, to: :schedule

  accessible_attr :name, :frequency, :start, :end, users: {}

  validates_presence_of :users

  def schedule
    @schedule ||= Schedule.new
  end

  def start
    return if schedule.start.nil?

    schedule.start.strftime('%m/%d/%Y %I:%M %p')
  end

  def end
    return if schedule.end.nil?

    schedule.end.strftime('%m/%d/%Y %I:%M %p')
  end

  def _submit
    ActiveRecord::Base.transaction do
      schedule.save!
      schedule.schedule_users.reload.destroy_all

      users.each do |user_id, priority|
        ScheduleUser.create(user_id: user_id, schedule: schedule, priority: priority)
      end
    end
    self.success = true
  end
  alias save submit

  private

  def initialize(args = {})
    super args_key_first args, :schedule
  end
end

class CreateScheduleForm < BaseForm
  include ActiveRecord::AttributeAssignment

  attr_accessor :select_user, :users, :success

  attr_writer :schedule

  nested_attributes :name, :project, :schedule_attributes, :user, to: :schedule

  accessible_attr :name, schedule_attributes: {}, users: {}

  validates_presence_of :users

  def schedule
    @schedule ||= Schedule.new
  end

  def schedule_attributes=(value)
    case value[:interval_unit]
    when 'day'
      populate_day_week_schedule_attributes(value, 0.days)
    when 'week'
      populate_day_week_schedule_attributes(value, 6.days)
    when 'biweek'
      populate_biweek_schedule_attributes(value)
    when 'triweek'
      populate_triweek_schedule_attributes(value)
    end

    value[:ends] = 'never'
    schedule.schedule_attributes = value
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

  def populate_day_week_schedule_attributes(value, duration)
    value[:end_time] = schedule_attributes_end_time(value, duration)
  end

  def populate_biweek_schedule_attributes(value)
    value[:interval_unit] = 'week'
    value[:interval] = 2
    value[:end_time] = schedule_attributes_end_time(value, 13.days)
  end

  def populate_triweek_schedule_attributes(value)
    value[:interval_unit] = 'week'
    value[:interval] = 3
    value[:end_time] = schedule_attributes_end_time(value, 20.days)
  end

  def schedule_attributes_end_time(value, duration)
    value[:end_time] = '11:59 PM' if value[:end_time].blank?

    "#{(Time.zone.parse(value[:start_date]) + duration)
      .strftime('%m/%d/%Y %I:%M %p')
      .split(' ')[0]} #{value[:end_time]}"
  end
end

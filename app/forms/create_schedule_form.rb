class CreateScheduleForm < BaseForm
  include ActiveRecord::AttributeAssignment

  attr_accessor :select_user, :users, :success

  attr_writer :schedule

  nested_attributes :name, :project, :schedule_attributes, :user, to: :schedule

  accessible_attr :name, schedule_attributes: {}, users: {}

  validates_presence_of :users
  validate :weekday_selected

  def schedule
    @schedule ||= Schedule.new
  end

  def schedule_attributes=(value)
    if value[:interval_unit] == 'biweek'
      set_biweek_schedule_attributes(value)
    elsif value[:interval_unit] == 'month'
      set_month_schedule_attributes(value)
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

  def set_biweek_schedule_attributes(value)
    value[:interval_unit] = 'week'
    value[:interval] = 2
    value[:end_time] = schedule_attributes_end_time(value, 2.weeks - 1.day)
  end

  def set_month_schedule_attributes(value)
    value[:end_time] = schedule_attributes_end_time(value, 1.month - 1.day)
  end

  def schedule_attributes_end_time(value, duration)
    value[:end_time] = '11:59 PM' if value[:end_time].blank?

    (Time.zone.parse(value[:start_date]) + duration)
        .strftime('%m/%d/%Y %I:%M %p')
        .split(' ')[0] + ' ' + value[:end_time]
  end

  def weekday_selected
    if schedule.weekly?
      present = Schedule::DAYS_OF_THE_WEEK.reduce(false) { |a, e| a || schedule_attributes.send(e).present? }
      errors.add(:base, 'Please select atleast one day of the week') unless present
    end
  end
end

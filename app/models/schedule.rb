class Schedule < ApplicationRecord
  include DataEventPublishing

  belongs_to :project
  belongs_to :user

  has_many :schedule_users, -> { order priority: :desc }, dependent: :destroy
  has_many :project_users, through: :project
  has_many :users, through: :schedule_users

  enum frequency: { daily: 0, weekly: 1, biweekly: 2, monthly: 3 }

  validates_presence_of :name, :start, :frequency, :project

  publishes_lifecycle_events

  def next_occurrence
    ice_cube_schedule.next_occurrence.start_time
  end

  def jobs
    Delayed::Job.where('handler LIKE ?', "%Schedule/#{id}\%")
  end

  def on_call_user
    schedule_users.max_by(&:priority).user if users.present?
  end

  def priority(user)
    schedule_users.where(user: user).first.try(:priority)
  end

  private

  def ice_cube_schedule
    schedule = IceCube::Schedule.new(start, end_time: self.end)

    case frequency
    when 'daily'
      schedule.add_recurrence_rule IceCube::Rule.daily(1)
    when 'weekly'
      schedule.add_recurrence_rule IceCube::Rule.weekly(1)
    when 'biweekly'
      schedule.add_recurrence_rule IceCube::Rule.weekly(2)
    when 'monthly'
      schedule.add_recurrence_rule IceCube::Rule.monthly(1)
    end
    schedule
  end
end

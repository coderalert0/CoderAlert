class Schedule < ApplicationRecord
  include DataEventPublishing

  belongs_to :project
  belongs_to :user

  has_many :schedule_users, -> { order priority: :desc }, dependent: :destroy
  has_many :users, through: :schedule_users

  enum frequency: { daily: 0, weekly: 1, biweekly: 2, monthly: 3 }

  validates_presence_of :name, :start, :frequency, :project

  publishes_lifecycle_events

  def next_occurrence
    ice_cube_schedule.next_occurrence.start_time
  end

  def next_occurrences_with_users(number)
    occurrences = []
    schedule_users = self.schedule_users.to_a

    ice_cube_schedule.next_occurrences(number, Time.now).each do |occurrence|
      schedule_users = reprioritize_users(schedule_users)

      occurrences << [occurrence, schedule_users.max_by(&:priority).user ]
    end

    occurrences
  end

  def reprioritize_users(schedule_users)
    num_users = schedule_users.count

    schedule_users.rotate!

    schedule_users.each_with_index do |schedule_user, index|
      schedule_user.priority = num_users - index
    end

    schedule_users
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

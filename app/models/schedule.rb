require 'schedule_attributes'

class Schedule < ApplicationRecord
  include ScheduleAttributes
  include DataEventPublishing

  belongs_to :project
  belongs_to :user

  has_many :schedule_users, -> { order priority: :desc }, dependent: :destroy
  has_many :users, through: :schedule_users

  has_schedule_attributes column_name: 'rule'

  INTERVAL_UNIT = %i[day week biweek month].freeze
  DAYS_OF_THE_WEEK = %i[sunday monday tuesday wednesday thursday friday saturday].freeze

  validates_presence_of :name, :schedule_attributes, :project

  delegate :interval_unit, to: :schedule_attributes

  publishes_lifecycle_events

  def next_occurrence
    rule.next_occurrence.start_time
  end

  def next_occurrences_with_users(number)
    occurrences = []

    rule.next_occurrences(number, Time.zone.now).each.with_index(1) do |occurrence, index|
      priority =
        if weekly?
          date_time = occurrence.start_time.to_datetime

          # need to decrement week number for Sundays (international vs USA)
          week_number = date_time.cwday == 7 ? date_time.cweek - 1 : date_time.cweek

          schedule_users.count - (week_number % schedule_users.count)
        else
          schedule_users.count - (index % schedule_users.count)
        end

      user = schedule_users.find_by(priority: priority).user

      occurrences << [occurrence, user]
    end

    occurrences
  end

  def weekly?
    schedule_attributes.interval_unit == 'week' && schedule_attributes.interval == 1
  end

  def biweekly?
    schedule_attributes.interval_unit == 'week' && schedule_attributes.interval == 2
  end

  def jobs
    Delayed::Job.where('handler LIKE ?', "%Schedule/#{id}\%")
  end

  def on_call_user
    schedule_users.max_by(&:priority).user if users.present?
  end

  def priority(user)
    schedule_users.find_by(user: user).try(:priority)
  end
end

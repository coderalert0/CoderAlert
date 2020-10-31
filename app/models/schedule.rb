require 'schedule_attributes'

class Schedule < ApplicationRecord
  include ScheduleAttributes
  include DataEventPublishing

  belongs_to :project
  belongs_to :user

  has_many :schedule_users, -> { order priority: :asc }, dependent: :destroy
  has_many :users, through: :schedule_users

  has_schedule_attributes column_name: 'rule'

  INTERVAL_UNIT = %i[day week biweek].freeze
  DAYS_OF_THE_WEEK = %i[sunday monday tuesday wednesday thursday friday saturday].freeze

  validates_presence_of :name, :schedule_attributes, :project

  delegate :interval_unit, to: :schedule_attributes

  publishes_lifecycle_events

  def next_occurrence
    rule.next_occurrence.start_time
  end

  def next_occurrences_with_users(number)
    occurrences = []

    rule.next_occurrences(number, rule.start_date).each.with_index do |occurrence, index|
      user = occurrence_user(occurrence, index)
      occurrences << [occurrence, user]
    end

    occurrences
  end

  def daily?
    schedule_attributes.interval_unit == 'day'
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
    rule.next_occurrences(20, rule.start_date).each_with_index do |occurrence, index|
      if occurrence.cover? Time.now
        return occurrence_user(occurrence, index)
      end
    end
  end

  def occurrence_user(occurrence, index)
    priority =
        if weekly?
          date_time = occurrence.start_time.to_datetime

          # need to decrement week number for Sundays (international vs USA)
          week_number = date_time.cwday == 7 ? date_time.cweek - 1 : date_time.cweek

          (week_number - 1) % schedule_users.count + 1
        else
          index % schedule_users.count + 1
        end

    schedule_users.find_by(priority: priority).user
  end

  def priority(user)
    schedule_users.find_by(user: user).try(:priority)
  end
end

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

  def daily?
    schedule_attributes.interval_unit == 'day'
  end

  def weekly?
    schedule_attributes.interval_unit == 'week' && schedule_attributes.interval == 1
  end

  def biweekly?
    schedule_attributes.interval_unit == 'week' && schedule_attributes.interval == 2
  end

  def on_call_user
    occurrences = rule.first(90)
    occurrence = occurrences[occurrence_index]

    return occurrence_user(occurrence_index) if occurrence.cover? Time.zone.now
  end

  def occurrence_index(date_time_now = Time.zone.now.to_datetime)
    start_date_time = rule.start_time.to_datetime

    if daily?
      (date_time_now - start_date_time).to_i
    elsif biweekly?
      date_time_now.cweek / 2 - start_date_time.cweek / 2
    elsif weekly?
      date_time_now.cweek - start_date_time.cweek
    end
  end

  def occurrence_user(index)
    priority = index % schedule_users.count

    user = schedule_users.find_by(priority: priority).user

    if user.pto?
      priorities = schedule_users.reject { |su| su.user.pto? }.map(&:priority)
      user = schedule_users.find_by(priority: priorities.sample).user
    end

    user
  end

  def occurrence_user_calendar(index)
    priority = index % schedule_users.size
    schedule_users.select{|su| su.priority == priority }[0].user
  end
end

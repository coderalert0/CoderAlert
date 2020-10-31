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

  def jobs
    Delayed::Job.where('handler LIKE ?', "%Schedule/#{id}\%")
  end

  def on_call_user
    occurrences = rule.first(90)
    occurrence = occurrences[occurrence_index]

    return occurrence_user(occurrence_index) if occurrence.cover? Time.now
  end

  def occurrence_index(date_time_now = DateTime.now)
    start_date_time = rule.start_date.to_datetime

    # need to decrement week number for Sundays (international vs USA)
    week_number_now = date_time_now.cwday == 7 ? date_time_now.cweek - 1 : date_time_now.cweek
    start_week_number = start_date_time.cwday == 7 ? start_date_time.cweek - 1 : start_date_time.cweek

    if daily?
      (date_time_now - start_date_time).to_i
    elsif biweekly?
      week_number_now / 2 - start_week_number / 2
    elsif weekly?
      week_number_now - start_week_number
    end
  end

  def occurrence_user(index)
    priority = index % schedule_users.count

    schedule_users.find_by(priority: priority).user
  end
end

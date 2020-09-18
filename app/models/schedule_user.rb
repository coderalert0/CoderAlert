class ScheduleUser < ApplicationRecord
  belongs_to :schedule
  belongs_to :user

  validates_presence_of :priority, :schedule, :user
end

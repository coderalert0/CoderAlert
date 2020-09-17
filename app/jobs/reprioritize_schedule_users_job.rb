class ReprioritizeScheduleUsersJob < ApplicationJob
  queue_as :default

  after_perform do |job|
    schedule = job.arguments.first
    ReprioritizeScheduleUsersJob.set(wait_until: schedule.next_occurrence).perform_later(schedule)
  end

  def perform(schedule)
    ActiveRecord::Base.transaction do
      schedule_users = schedule.schedule_users
      active_schedule_user = schedule_users.max_by(&:priority)

      schedule_users.each do |schedule_user|
        if schedule_user == active_schedule_user
          schedule_user.update!(priority: 1)
        else
          schedule_user.increment!(:priority)
        end
      end
    end
  end
end

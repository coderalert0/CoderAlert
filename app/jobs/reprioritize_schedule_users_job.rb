class ReprioritizeScheduleUsersJob < ApplicationJob
  queue_as :default

  after_perform do |job|
    schedule = job.arguments.first
    ReprioritizeScheduleUsersJob.set(wait_until: schedule.next_occurrence).perform_later(schedule)
  end

  def perform(schedule)
    ActiveRecord::Base.transaction do
      schedule_users = schedule.schedule_users.reload
      num_users = schedule_users.count

      schedule.schedule_users.rotate.each_with_index do |schedule_user, index|
        schedule_user.update(priority: num_users - index)
      end
    end
  end
end

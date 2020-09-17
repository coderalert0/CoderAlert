class ScheduleListener
  def on_schedule_created(schedule)
    ReprioritizeScheduleUsersJob.set(wait_until: schedule.next_occurrence).perform_later(schedule)
  end

  def on_schedule_updated(schedule, _block)
    schedule.jobs.destroy_all
    ReprioritizeScheduleUsersJob.set(wait_until: schedule.next_occurrence).perform_later(schedule)
  end

  def on_schedule_destroyed(schedule)
    schedule.jobs.destroy_all
  end
end

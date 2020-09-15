class Schedule < ApplicationRecord
  belongs_to :project

  enum frequency: { daily: 0, weekly: 1, biweekly: 2, monthly: 3 }

  def schedule
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

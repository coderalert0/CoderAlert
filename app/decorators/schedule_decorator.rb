class ScheduleDecorator < ApplicationDecorator
  delegate_all

  def start_datetime
    date = schedule_attributes.start_date
    time = schedule_attributes.start_time
    date_time = "#{date} #{time}"

    DateTime.parse(date_time).strftime('%m/%d/%Y %I:%M %p')
  end

  def selected_interval_unit
    return 'week' if weekly?
    return 'biweek' if biweekly?

    interval_unit
  end

  def interval_unit_display
    if weekly?
      h.t(:week, scope: %i[schedule interval_unit])
    elsif biweekly?
      h.t(:biweek, scope: %i[schedule interval_unit])
    else
      h.t(interval_unit, scope: %i[schedule interval_unit])
    end
  end
end

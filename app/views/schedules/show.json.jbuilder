json.array! @schedule.rule.first(365).each do |occurrence|
  index = @schedule.occurrence_index(occurrence.start_time.to_datetime)
  user = @schedule.occurrence_user_calendar(index)

  json.title user.first_name
  json.color user.first_name.generate_random_color
  json.start occurrence.start_time
  json.end occurrence.end_time
end

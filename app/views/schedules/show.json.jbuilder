json.array! @schedule.rule.first(90).each do |occurrence|
  index = @schedule.occurrence_index(occurrence.start_time.to_datetime)

  json.title @schedule.occurrence_user(index).first_name
  json.color @schedule.occurrence_user(index).first_name.generate_random_color
  json.start occurrence.start_time
  json.end occurrence.end_time
end

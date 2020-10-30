json.array!(@schedule.next_occurrences_with_users(180)) do |occurrence|
  json.id occurrence[1].id
  json.title occurrence[1].first_name
  json.color occurrence[1].first_name.generate_random_color
  json.start occurrence[0]
  json.end occurrence[0].end_time
end

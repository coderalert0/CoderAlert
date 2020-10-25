json.array!(@schedule.next_occurrences_with_users(180)) do |occurrence|
  frequency_map = { 'daily' => 1.day, 'weekly' => 1.week, 'biweekly' => 2.weeks, 'monthly' => 1.month }.freeze

  json.id occurrence[1].id
  json.title occurrence[1].decorate.full_name
  json.color occurrence[1].first_name.generate_random_color
  json.start occurrence[0]
  json.end occurrence[0] + frequency_map[@schedule.frequency]
end

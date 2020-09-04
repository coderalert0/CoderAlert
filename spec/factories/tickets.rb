FactoryBot.define do
  factory :ticket do
    title { 'My ticket' }
    status { 'In Progress' }
    priority { 'Low' }
    description { 'You know what Im sayin?' }
    user
    project
  end
end

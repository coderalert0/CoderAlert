FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@coderalert.com" }
    first_name { 'Gurpreet' }
    last_name { 'Dhaliwal' }
    password { 'wer432' }
  end
end

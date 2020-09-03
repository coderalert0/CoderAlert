FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@coderalert.com" }
    password { 'wer432' }
  end
end

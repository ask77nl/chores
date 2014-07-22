# Read about factories at https://github.com/thoughtbot/factory_girl
require 'faker'

FactoryGirl.define do
  factory :chore do
    title {Faker::Lorem.sentence} 
    user_id {Faker::Number.number(3)} 
    email_id {Faker::Number.number(3)}
    choretype_id {Faker::Number.number(3)}
    project_id {Faker::Number.number(3)}
  end
end

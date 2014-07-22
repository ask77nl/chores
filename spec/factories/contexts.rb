# Read about factories at https://github.com/thoughtbot/factory_girl
require 'faker'

FactoryGirl.define do
  factory :context do
    name {Faker::Lorem.word}
    user_id {Faker::Number.number(3)} 
  end
end

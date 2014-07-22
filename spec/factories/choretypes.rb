# Read about factories at https://github.com/thoughtbot/factory_girl
require 'faker'

FactoryGirl.define do
  factory :choretype do
    name {Faker::Lorem.word}
  end
end

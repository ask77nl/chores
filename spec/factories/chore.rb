# Read about factories at https://github.com/thoughtbot/factory_girl
require 'faker'

FactoryGirl.define do
  factory :chore do
    title {Faker::Lorem.sentence.tr!(" ", "_")} 
    user_id {Faker::Number.number(3)} 
    email_id {Faker::Number.number(3)}
    choretype_id {Faker::Number.number(3)}
    project_id {Faker::Number.number(3)}
    deadline {Time.at(Time.new(2014).to_f + rand * (Time.now.to_f - Time.new(2014).to_f)).to_date}
  end
end

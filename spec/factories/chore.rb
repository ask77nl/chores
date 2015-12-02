# Read about factories at https://github.com/thoughtbot/factory_girl
require 'faker'

FactoryGirl.define do
  factory :chore do
    title {Faker::Lorem.sentence.tr!(" ", "_")} 
    user_id {Faker::Number.number(3)} 
    email_id {Faker::Number.number(3)}
    choretype_id {Faker::Number.number(3)}
    project_id {Faker::Number.number(3)}
    startdate {Time.at(Time.new(2014).to_f + rand * (Time.now.to_f - Time.new(2014).to_f)).to_date}
    deadline {startdate + rand(30)}
    #mocking up schedule in the format, that is received by a selector form, which is JSON string
    schedule "{\"interval\":1,\"until\":null,\"count\":null,\"validations\":null,\"rule_type\":\"IceCube::DailyRule\"}"
    archived false
  end
end

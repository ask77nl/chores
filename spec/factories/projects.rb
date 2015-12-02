require 'faker'

FactoryGirl.define do
factory :project do
    title {Faker::Lorem.sentence.tr!(" ", "_")} 
    user_id {Faker::Number.number(3)}
    context_id {Faker::Number.number(3)}
    archived false
 end
end


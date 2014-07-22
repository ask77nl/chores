require 'faker'

FactoryGirl.define do
factory :project do
    title {Faker::Lorem.sentence} 
    user_id {Faker::Number.number(3)}
 end
end


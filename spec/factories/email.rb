require 'faker'


FactoryGirl.define do
factory :email do
    from {Faker::Internet.email}
    to {Faker::Internet.email}
    subject {Faker::Lorem.sentence}
    body {Faker::Lorem.paragraph}
    user_id {Faker::Number.number(3)}
 end
end


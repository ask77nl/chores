require 'faker'

FactoryGirl.define do
factory :emailaccount do
    email_address {Faker::Internet.email}
    authentication_token {Faker::Internet.password(30)}
    user_id {Faker::Number.number(3)}
 end
end

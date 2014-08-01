require 'faker'


FactoryGirl.define do
factory :email do
    from {Faker::Internet.email}
    to {Faker::Internet.email}
    subject {Faker::Lorem.sentence}
    body {Faker::Lorem.paragraph}
    user_id {Faker::Number.number(3)}
    datetime {Time.at(Time.new(2014).to_f + rand * (Time.now.to_f - Time.new(2014).to_f)).to_date}
 end
end


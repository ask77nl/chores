require 'faker'


FactoryGirl.define do
factory :email do
    from {Faker::Internet.email}
    to {Faker::Internet.email}
    subject {Faker::Lorem.sentence.tr!(" ", "_")}
    body {Faker::Lorem.paragraph}
    user_id {Faker::Number.number(3)}
    datetime {Time.zone.at(Time.new(2014).to_f + rand * (Time.zone.now.to_f - Time.new(2014).to_f))}
 end
end


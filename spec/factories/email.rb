FactoryGirl.define do
factory :email do
    from "ask@alleko.com"
    to "ask@alleko.com"
    subject "Do the stuff"
    body "This is the description" 
    user_id 1
 end
end


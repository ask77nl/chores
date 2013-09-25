# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :chore do
    title "test chore"
    user_id 1
    email_id 1
    choretype_id 1
    project_id 1
  end
end

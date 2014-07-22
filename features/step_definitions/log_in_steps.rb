Given(/^Visitor visits the login  page$/) do
  visit('/login')
end

Given(/^He is a registered user$/) do
  user = FactoryGirl.attributes_for(:user)
  User.create!(user)
end

When(/^He enters correct email address and passowrd$/) do
  user = FactoryGirl.create(:user)
  fill_in('user_email', :with => user.email)
  fill_in('user_password', :with => user.password)
  click_button('Sign in')
end

Then(/^He should be logged in$/) do
  page.should have_content('Signed in as:')
end


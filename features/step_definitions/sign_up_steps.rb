Given(/^Visitor visits the home page$/) do
  visit '/'
end

When(/^He is not logged in$/) do
  page.should_not have_content('Signed in as:')
end

Then(/^He should see the sign up button$/) do
  page.should have_content('Sign up now')
end

Then(/^he should see the log in button$/) do
  page.should have_content('Log In')
end

Given(/^Visitor visits the sign\-up page$/) do
 visit('/users/sign_up')
end

When(/^he enters email address and password$/) do
  user = FactoryGirl.build(:user)
#  user = Factory(:user)
  fill_in('user_email', :with => user.email)
  fill_in('user_password', :with => user.password)
  fill_in('user_password_confirmation', :with => user.password)
  click_button('Sign up')
end

Then(/^Site must sign him up$/) do
  page.should have_content('Signed in as:')
end


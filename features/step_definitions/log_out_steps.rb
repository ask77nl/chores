Given(/^Visitor is logged it$/) do
  visit('/login')
  user = FactoryGirl.attributes_for(:user)
  User.create!(user)
  user = FactoryGirl.build(:user)
  fill_in('user_email', :with => user.email)
  fill_in('user_password', :with => user.password)
  click_button('Sign in')

end

When(/^He clicks on log out button$/) do
  visit('/login')
#  print "page is:",page.html
  click_link("Log Out")
end

Then(/^He should see the home page$/) do
  expect(page).to_not have_content('Signed in as:')
  expect(page).to  have_content('Log In')

end

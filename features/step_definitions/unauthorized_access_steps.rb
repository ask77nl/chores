Given /^He visits the (\w+)$/ do |pagename|
 visit '/'+pagename
end

Then(/^He should be redirected to sign\-in page$/) do
 page.should have_content('You need to sign in or sign up before continuing')
end

Given(/^user1 created chore "(.*?)"$/) do |choretitle|
    user = FactoryGirl.create(:user, :email => "ask@alleko.com")
    context = FactoryGirl.create(:context)
    project = FactoryGirl.create(:project, :context_id => context.id)
    email = FactoryGirl.create(:email)
    choretype = FactoryGirl.create(:choretype)
    FactoryGirl.create(:chore, :title => choretitle, :user_id => user.id, :project_id => project.id, :email_id => email.id, :choretype_id => choretype.id)
end

Given(/^user2 logged in$/) do 
  user = FactoryGirl.create(:user, :email => "wrong-user@chores.com", :password => "wrong-user", :password_confirmation => "wrong-user")
   visit('/login')
   fill_in('user_email', :with => user.email)
   fill_in('user_password', :with => user.password)
   click_button('Sign in')
   page.should have_content('Signed in as:')
end

Given(/^user2 visits the chores$/) do 
  visit('/chores')
end

Then(/^He should not see "(.*?)"$/) do |choretitle|
  print page
  page.should_not have_content(choretitle)
end



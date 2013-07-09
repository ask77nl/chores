Given /^He visits the (\w+)$/ do |pagename|
 visit '/'+pagename
end

Then(/^He should be redirected to sign\-in page$/) do
 page.should have_content('You need to sign in or sign up before continuing')
end


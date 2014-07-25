require 'spec_helper'

describe "Header", :type => :feature do
  describe "checking header at Home page" do
   it "when user is not logged in, it should contain link to home and log in" do
      visit '/'
      expect(page).to have_link('Log In', href: new_user_session_path)
      expect(page).to have_link('Chores', href: root_path)
    end
  end

 describe "checking header at Home page after logged in" do
   it "when user is logged in, it should contain the menu, sign in info and logout link" do
  
      user = FactoryGirl.create(:user)
      visit new_user_session_path
      fill_in('user_email', :with => user.email)
      fill_in('user_password', :with => user.password)
      click_button('Sign in')

      visit '/'
      expect(page).to have_link('Log Out', href: destroy_user_session_path)
      expect(page).to have_link('Home', href: root_path)
      expect(page).to have_link('Emails', href: emails_path)
      expect(page).to have_link('Chores', href: chores_path)
      expect(page).to have_link('Projects', href: projects_path)
      expect(page).to have_link('Contexts', href: contexts_path)
      expect(page).to have_content('Signed in as: '+user.email)
    end
  end
  

end


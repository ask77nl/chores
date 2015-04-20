require 'spec_helper'

describe "Header", :type => :feature do
  context "user is not logged in" do
   describe "checking header at Home page" do
    it "it should contain link to home and log in" do
       visit '/'
       expect(page).to have_link('Log In', href: new_user_session_path)
       expect(page).to have_link('Chores', href: root_path)
     end
   end
 end

 context "user is logged in" do

  before do
    @user = FactoryGirl.create(:user)
    visit new_user_session_path
    fill_in('user_email', :with => @user.email)
    fill_in('user_password', :with => @user.password)
    click_button('Sign in')
  end

  describe "checking header at Home page after logged in" do
    it "it should contain the menu, sign in info and logout link" do
  
      visit '/'
      expect(page).to have_link('Log Out', href: destroy_user_session_path)
      expect(page).to have_link('Home', href: root_path)
      expect(page).to have_link('Emails', href: emails_path)
      expect(page).to have_link('Calendar', href: calendar_chores_path)
      expect(page).to have_link('Status Quo', href: status_quo_chores_path)
      expect(page).to have_link('Projects', href: projects_path)
      expect(page).to have_link('Contexts', href: contexts_path)
      expect(page).to have_content('Signed in as: '+@user.email)
    end

    it "when user hits log out, it should not see the Signed as message" do
     visit('/')
     click_link("Log Out")
     expect(page).to_not have_content('Signed in as:')
     expect(page).to  have_content('Log In')
    end
   end
  end

end


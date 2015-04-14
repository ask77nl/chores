require 'spec_helper'

describe "Sign-up", :type => :feature do
  context "user is not logged in" do
   describe "user is visiting home page" do
    it "it should be able to sign up" do
       visit '/'
       expect(page).to have_link('Sign up now', href: new_user_registration_path)

       click_link('Sign up now')

       user = FactoryGirl.build(:user)
       fill_in('user_email', :with => user.email)
       fill_in('user_password', :with => user.password)
       fill_in('user_password_confirmation', :with => user.password)
       click_button('Sign up')

       expect(page).to have_content('Signed in as: '+user.email)
       
     end
   end
 end
end


require 'spec_helper'

describe "Emails", :type => :feature do

 context "user is logged in" do

  before do
    @user = FactoryGirl.create(:user)
    visit new_user_session_path
    fill_in('user_email', :with => @user.email)
    fill_in('user_password', :with => @user.password)
    click_button('Sign in')
  end

  after do
   User.delete_all
  end


  end
end


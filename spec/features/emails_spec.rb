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

  describe "when there is no emails" do
    it "it should show an empty list" do
      visit emails_path
      expect(page).to have_content('No emails yet, create one!')
      expect(page).to have_link('New Email', new_email_path)
    end
   end
 

   describe "when user creates email" do
    it "it should show the email and represent it in the list" do
      visit emails_path
      click_link("New Email")

      email = FactoryGirl.build(:email)
      fill_in('email_from', :with => email.from)
      fill_in('email_to', :with => email.to)
      fill_in('email_subject', :with => email.subject)
      fill_in('email_body', :with => email.body)
      click_button('Create Email')

      expect(page).to have_content('Email was successfully created.')
      expect(page).to have_content('From: '+email.from)
      expect(page).to have_content('To: '+email.to)
      expect(page).to have_content('Subject: '+email.subject)
      expect(page).to have_content('Body: '+email.body)

      visit emails_path
     
      expect(page).to have_content(email.from)
      expect(page).to have_content(email.to)
      expect(page).to have_content(email.subject)
      expect(page).to have_content(email.body)

    end
   end

   describe "when many users create email" do
    it "should show each users only his emails" do
     email = FactoryGirl.create(:email,user_id: @user.id)
     other_user = FactoryGirl.create(:user)
     other_email = FactoryGirl.create(:email,user_id: other_user.id)
   
     visit emails_path

     expect(page).to have_content(email.subject)
     expect(page).to have_no_content(other_email.subject)
      
    end
  end
   
   describe "after there are some emails" do
    it "should be able to show it" do
     email = FactoryGirl.create(:email,user_id: @user.id)
     visit emails_path
     expect(page).to have_content(email.subject)
     click_link("Show")
     
     expect(page).to have_content('From: '+email.from)
     expect(page).to have_content('To: '+email.to)
     expect(page).to have_content('Subject: '+email.subject)
     expect(page).to have_content('Body: '+email.body)
    end
   end
   
    it "should be able to edit it" do
     email = FactoryGirl.create(:email,user_id: @user.id)
     visit emails_path
     expect(page).to have_content(email.subject)
     click_link("Edit")
   
     expect(find_field('email_from').value).to  eq email.from
     expect(find_field('email_to').value).to  eq email.to
     expect(find_field('email_subject').value).to  eq email.subject
     expect(find_field('email_body').value).to  eq email.body

     new_subject = "new subject"
     fill_in('email_subject', :with => new_subject)

     click_button("Update Email")
 
     expect(page).to have_content('Subject: '+new_subject)

     visit emails_path

     expect(page).to have_content(new_subject)
   end

   it "should be able to delete it" do
     email = FactoryGirl.create(:email,user_id: @user.id)
     visit emails_path
     expect(page).to have_content(email.subject)
     click_link("Destroy")
#     click_button("OK")

     expect(page).to have_no_content(email.subject)

   end

   
  end
end


require 'spec_helper'

describe "Contexts", :type => :feature do

 context "user is logged in" do

  before do
    @user = FactoryGirl.create(:user)
    visit new_user_session_path
    fill_in('user_email', :with => @user.email)
    fill_in('user_password', :with => @user.password)
    click_button('Sign in')
  end

  describe "when there is no contexts" do
    it "it should show an empty list" do
      visit contexts_path
      expect(page).to have_content('No contexts yet, create one!')
      expect(page).to have_link('New Context', new_context_path)
    end
   end
 

   describe "when user creates context" do
    it "it should show the context and represent it in the list" do
      visit contexts_path
      click_link("New Context")

      context = FactoryGirl.build(:context)
      fill_in('context_name', :with => context.name)
      click_button('Create Context')

      expect(page).to have_content('Context was successfully created.')
      expect(page).to have_content('Name: '+context.name)
      
      visit contexts_path
     
      expect(page).to have_content(context.name)
      
    end
   end

   describe "when many users create context" do
    it "should show each users only his contexts" do
     context = FactoryGirl.create(:context,user_id: @user.id)
     other_user = FactoryGirl.create(:user)
     other_context = FactoryGirl.create(:context,user_id: other_user.id)
   
     visit contexts_path

     expect(page).to have_content(context.name)
     expect(page).to have_no_content(other_context.name)
      
    end
  end
   
   describe "after there are some contexts" do
    it "should be able to show it" do
     context = FactoryGirl.create(:context,user_id: @user.id)
     visit contexts_path
     expect(page).to have_content(context.name)
     click_link("Show")
     
     expect(page).to have_content('Name: '+context.name)
    end
   end
   
    it "should be able to edit it" do
     context = FactoryGirl.create(:context,user_id: @user.id)
     visit contexts_path
     expect(page).to have_content(context.name)
     click_link("Edit")
   
     expect(find_field('context_name').value).to  eq context.name

     new_name = "new name"
     fill_in('context_name', :with => new_name)

     click_button("Update Context")
 
     expect(page).to have_content('Name: '+new_name)

     visit contexts_path

     expect(page).to have_content(new_name)
   end

   it "should be able to delete it" do
     context = FactoryGirl.create(:context,user_id: @user.id)
     visit contexts_path
     expect(page).to have_content(context.name)
     click_link("Destroy")
#     click_button("OK")

     expect(page).to have_no_content(context.name)

   end

   
  end
end


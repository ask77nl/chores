require 'spec_helper'

describe "Chores", :type => :feature do

 context "user is logged in" do

  before do
    @user = FactoryGirl.create(:user)
    @context = FactoryGirl.create(:context, user_id: @user.id)
    @project = FactoryGirl.create(:project, context_id: @context.id, user_id: @user.id)
    @choretype = FactoryGirl.create(:choretype, user_id: @user.id)
    @email = FactoryGirl.create(:email, user_id: @user.id)
    visit new_user_session_path
    fill_in('user_email', :with => @user.email)
    fill_in('user_password', :with => @user.password)
    click_button('Sign in')
  end
 
  after do
    User.delete_all
    Context.delete_all
    Project.delete_all
    Choretype.delete_all
    Email.delete_all
  end


  describe "when there is no chores" do
    it "it should show an empty list" do
      visit chores_path
      expect(page).to have_content('No chores yet, create one!')
      expect(page).to have_link('New Chore', new_chore_path)
    end
   end
 

   describe "when user creates chore" do
    it "it should show the chore and represent it in the list" do
      visit chores_path
      click_link("New Chore")

      chore = FactoryGirl.build(:chore, project_id: @project.id, email_id: @email.id, choretype_id: @choretype.id, user_id: @user.id)
      fill_in('chore_title', :with => chore.title)
      select(@email.subject,:from => 'chore[email_id]')
      select(@choretype.name,:from => 'chore[choretype_id]')
      select(@project.subject,:from => 'chore[project_id]')
      
      click_button('Create Chore')

      expect(page).to have_content('Chore was successfully created.')
      expect(page).to have_content('Title: '+chore.title)
      
      
      visit chores_path
     
      expect(page).to have_content(chore.title)
      expect(page).to have_content(@context.name)
      
    end
   end

   describe "when many users create chore" do
    it "should show each users only his chores" do
      chore = FactoryGirl.create(:chore, context_id: @context.id, user_id: @user.id)

     other_user = FactoryGirl.create(:user)
     other_chore = FactoryGirl.create(:chore,user_id: other_user.id, context_id: @context.id)
   
     visit chores_path

     expect(page).to have_content(chore.title)
     expect(page).to have_no_content(other_chore.title)
      
    end
  end

   describe "when there is a parent chore" do
    it "should be visible and available for selection on edit" do
     
      parent_chore = FactoryGirl.create(:chore, context_id: @context.id, user_id: @user.id) 
      
      visit new_chore_path
     
      expect(page).to have_select('chore[parent_chore_id]', :options => ['None',parent_chore.title])

      chore = FactoryGirl.create(:chore, context_id: @context.id, user_id: @user.id, parent_chore_id: parent_chore.id)
     
     visit chores_path
     expect(page).to have_content(parent_chore.title)
     expect(page).to have_content(chore.title)


    end
  end

   
   describe "after there are some chores" do
    it "should be able to show it" do
      chore = FactoryGirl.create(:chore, context_id: @context.id, user_id: @user.id)

     visit chores_path
     expect(page).to have_content(chore.title)
     click_link("Show")
     
     expect(page).to have_content('Title: '+chore.title)
    end
   end
   
    it "should be able to edit it" do
       parent_chore = FactoryGirl.create(:chore, context_id: @context.id, user_id: @user.id)

      chore = FactoryGirl.create(:chore, context_id: @context.id, user_id: @user.id)

     visit chores_path
     expect(page).to have_content(chore.title)
     click_link("Edit", :href =>"/chores/"+chore.id.to_s+"/edit")
   
     expect(find_field('chore_title').value).to  eq chore.title

     new_title = "new title"
     fill_in('chore_title', :with => new_title)

     select(parent_chore.title,:from => 'chore[parent_chore_id]')

     click_button("Update Chore")
 
     expect(page).to have_content('Title: '+new_title)
     expect(page).to have_content('Parent chore: '+parent_chore.title)

     visit chores_path

     expect(page).to have_content(new_title)
     expect(page).to have_content(parent_chore.title)
   end

   it "should be able to delete it" do
      chore = FactoryGirl.create(:chore, context_id: @context.id, user_id: @user.id)

     visit chores_path
     expect(page).to have_content(chore.title)
     click_link("Destroy")
#     click_button("OK")

     expect(page).to have_no_content(chore.title)

   end

   
  end
end


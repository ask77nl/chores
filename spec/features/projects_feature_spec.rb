require 'spec_helper'

describe "Projects", :type => :feature do

 context "user is logged in" do

  before do
    @user = FactoryGirl.create(:user)
    @context = FactoryGirl.create(:context, user_id: @user.id)
    @choretype = FactoryGirl.create(:choretype)
    @email = FactoryGirl.create(:email,user_id: @user.id)
    visit new_user_session_path
    fill_in('user_email', :with => @user.email)
    fill_in('user_password', :with => @user.password)
    click_button('Sign in')
  end
 
  after do
    User.delete_all
    Context.delete_all
  end


  describe "when there is no projects" do
    it "it should show an empty list" do
      visit projects_path
      expect(page).to have_content('No projects yet, create one!')
      expect(page).to have_link('New Project', new_project_path)
    end
   end
 

   describe "when user creates project" do
    it "it should show the project and represent it in the list" do
      visit projects_path
      click_link("New Project")

      project = FactoryGirl.build(:project, context_id: @context.id, user_id: @user.id)
      fill_in('project_title', :with => project.title)
      click_button('Create Project')

      expect(page).to have_content('Project was successfully created.')
      expect(page).to have_content(project.title)
      
      visit projects_path
     
      expect(page).to have_content(project.title)
      
      
    end
   end

   describe "when many users create project" do
    it "should show each users only his projects" do
      project = FactoryGirl.create(:project, context_id: @context.id, user_id: @user.id)

     other_user = FactoryGirl.create(:user)
     other_project = FactoryGirl.create(:project,user_id: other_user.id, context_id: @context.id)
   
     visit projects_path

     expect(page).to have_content(project.title)
     expect(page).to have_no_content(other_project.title)
      
    end
  end

   describe "when there is a parent project" do
    it "should be visible and available for selection on edit" do
     
      parent_project = FactoryGirl.create(:project, context_id: @context.id, user_id: @user.id) 
      
      visit new_project_path
     
      expect(page).to have_select('project[parent_project_id]', :options => ['None',parent_project.title])

      project = FactoryGirl.create(:project, context_id: @context.id, user_id: @user.id, parent_project_id: parent_project.id)
     
     visit projects_path
     expect(page).to have_content(parent_project.title)
     expect(page).to have_content(project.title)


    end
  end

   
   describe "after there are some projects" do
    it "should be able to show it" do
      project = FactoryGirl.create(:project, context_id: @context.id, user_id: @user.id)

     visit projects_path
     expect(page).to have_content(project.title)
     click_link(project.title)
     
     expect(page).to have_content('Title: '+project.title)
    end
    it "its chores should be visible as well on the project view" do
      project = FactoryGirl.create(:project, context_id: @context.id, user_id: @user.id)
      chore = FactoryGirl.create(:chore, project_id: project.id, email_id: @email.id, choretype_id: @choretype.id, user_id: @user.id)

     visit projects_path
     expect(page).to have_content(project.title)
     expect(page).to have_content(chore.title)
     expect(page).to have_content(@choretype.name)
     click_link(project.title)
     
     expect(page).to have_content('Title: '+project.title)
    end
   end
   
   
    it "should be able to edit it" do
     
      parent_project = FactoryGirl.create(:project, context_id: @context.id, user_id: @user.id)
      project = FactoryGirl.create(:project, context_id: @context.id, user_id: @user.id)

     visit projects_path
     expect(page).to have_content(project.title)
     
     
     edit_url = "/projects/"+project.id.to_s+"/edit"
     edit_anchor = "//a[@href='"+edit_url+"']"
     find(:xpath, edit_anchor).click
   
     expect(find_field('project_title').value).to  eq project.title

     new_title = "new title"
     fill_in('project_title', :with => new_title)

     select(parent_project.title,:from => 'project[parent_project_id]')

     click_button("Update Project")
 
     expect(page).to have_content(new_title)
     expect(page).to have_content(parent_project.title)
   end
   
   it "should be able to delete it" do
      project = FactoryGirl.create(:project, context_id: @context.id, user_id: @user.id)

     visit projects_path
     expect(page).to have_content(project.title)
     delete_url = "/projects/"+project.id.to_s
     delete_filter = "//a[@href='"+delete_url+"' and @class = 'delete']"
     find(:xpath, delete_filter).click

     expect(page).to have_no_content(project.title)

   end
   describe "after an active project already exist" do
    it "should be able to mark it as a someday project, it must become a root project and be visible only in the someday project list" do
      parent_project = FactoryGirl.create(:project, context_id: @context.id, user_id: @user.id)
      project = FactoryGirl.create(:project, context_id: @context.id, user_id: @user.id, parent_project_id: parent_project.id)
      chore = FactoryGirl.create(:chore, project_id: project.id, email_id: @email.id, choretype_id: @choretype.id, user_id: @user.id)
     visit projects_path
     expect(page).to have_content(project.title)
     
     edit_url = "/projects/"+project.id.to_s+"/edit"
     edit_anchor = "//a[@href='"+edit_url+"']"
     find(:xpath, edit_anchor).click
   
     expect(find_field('project_title').value).to  eq project.title


     find(:css, "#project_someday").set(true)
      
     click_button("Update Project")
     expect(page).to have_content('Someday/May be')

     visit projects_path

     expect(page).not_to have_content(project.title)
     expect(page).not_to have_content(chore.title)
     
     visit someday_projects_path
     
     expect(page).to have_content(project.title)
     expect(page).to have_content(chore.title)
   end
  end

 describe "after we kill a medium project" do
 it "its children projects got promoted and chores got orphaned" do
      project = FactoryGirl.create(:project, context_id: @context.id, user_id: @user.id)
      medium_project = FactoryGirl.create(:project, :parent_project_id => project.id, :context_id => @context.id, :user_id => @user.id)
      bottom_project =  FactoryGirl.create(:project, :parent_project_id => medium_project.id, :context_id => @context.id, :user_id => @user.id)
      project.reload
      medium_project.reload
      bottom_project.reload
      medium_chore = FactoryGirl.create(:chore, :project_id => medium_project.id, :user_id => @user.id, :choretype_id => @choretype.id)

     visit projects_path
     expect(page).to have_content(project.title)
     expect(page).to have_content(medium_project.title)
     expect(page).to have_content(bottom_project.title)
     expect(page).to have_content(medium_chore.title)


     delete_url = "/projects/"+medium_project.id.to_s
     delete_filter = "//a[@href='"+delete_url+"' and @class = 'delete']"
     find(:xpath, delete_filter).click

     expect(page).to have_content(project.title)
     expect(page).not_to have_content(medium_project.title)
     expect(page).to have_content(bottom_project.title)
     expect(page).not_to have_content(medium_chore.title)

     visit project_path(bottom_project.id)
    
     expect(page).to have_content(project.title)

     visit status_quo_chores_path

     expect(page).to have_content(medium_chore.title)


   end
 end
 
end 
end


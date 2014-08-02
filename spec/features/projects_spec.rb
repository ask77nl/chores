require 'spec_helper'

describe "Projects", :type => :feature do

 context "user is logged in" do

  before do
    @user = FactoryGirl.create(:user)
    @context = FactoryGirl.create(:context, user_id: @user.id)
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
      expect(page).to have_content('Title: '+project.title)
      
      visit projects_path
     
      expect(page).to have_content(project.title)
      expect(page).to have_content(@context.name)
      
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
     click_link("Show")
     
     expect(page).to have_content('Title: '+project.title)
    end
   end
   
    it "should be able to edit it" do
       parent_project = FactoryGirl.create(:project, context_id: @context.id, user_id: @user.id)

      project = FactoryGirl.create(:project, context_id: @context.id, user_id: @user.id)

     visit projects_path
     expect(page).to have_content(project.title)
     click_link("Edit", :href =>"/projects/"+project.id.to_s+"/edit")
   
     expect(find_field('project_title').value).to  eq project.title

     new_title = "new title"
     fill_in('project_title', :with => new_title)

     select(parent_project.title,:from => 'project[parent_project_id]')

     click_button("Update Project")
 
     expect(page).to have_content('Title: '+new_title)
     expect(page).to have_content('Parent project: '+parent_project.title)

     visit projects_path

     expect(page).to have_content(new_title)
     expect(page).to have_content(parent_project.title)
   end

   it "should be able to delete it" do
      project = FactoryGirl.create(:project, context_id: @context.id, user_id: @user.id)

     visit projects_path
     expect(page).to have_content(project.title)
     click_link("Destroy")
#     click_button("OK")

     expect(page).to have_no_content(project.title)

   end

   
  end
end

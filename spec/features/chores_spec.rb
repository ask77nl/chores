require 'spec_helper'

describe "Chores", :type => :feature do

 context "user is logged in" do

  before do
    @user = FactoryGirl.create(:user)
    @context = FactoryGirl.create(:context, user_id: @user.id)
    @project = FactoryGirl.create(:project, context_id: @context.id, user_id: @user.id)
    @choretype = FactoryGirl.create(:choretype)
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
      select(@project.title,:from => 'chore[project_id]')
      fill_in('chore_datetime', :with => chore.deadline.to_s(:due_date))
      
      click_button('Create Chore')
  
     puts page.body

      expect(page).to have_content('Chore was successfully created.')
      expect(page).to have_content('Title: '+chore.title)
      expect(page).to have_content('Email: '+@email.subject)
      expect(page).to have_content('Type: '+@choretype.name)
      expect(page).to have_content('Project: '+@project.title)
      
      
      visit chores_path
     
      expect(page).to have_content(chore.title)
      expect(page).to have_content(@context.name)
      expect(page).to have_content(@email.subject)
      expect(page).to have_content(@choretype.name)
      expect(page).to have_content(@project.title)

      
    end
   end

describe "when there are chores of several contexts and types" do
    it "should filter chores by context and type" do

    other_context = FactoryGirl.create(:context, user_id: @user.id)
    other_project = FactoryGirl.create(:project, context_id: other_context.id, user_id: @user.id)
    other_choretype = FactoryGirl.create(:choretype)

    chore_usual = FactoryGirl.create(:chore, project_id: @project.id, email_id: @email.id, choretype_id: @choretype.id, user_id: @user.id)
   
    chore_other_context = FactoryGirl.create(:chore, project_id: other_project.id, email_id: @email.id, choretype_id: @choretype.id, user_id: @user.id)
  
    chore_other_type = FactoryGirl.create(:chore, project_id: @project.id, email_id: @email.id, choretype_id: other_choretype.id, user_id: @user.id)

     visit chores_path(:context => @context.id, :choretype =>@choretype.id)

     expect(page).to have_content(chore_usual.title)
     expect(page).to have_no_content(chore_other_context.title)
     expect(page).to have_no_content(chore_other_type.title)
   
     expect(page).to have_content(other_context.name)
     click_link(other_context.name)
  
     expect(page).to have_no_content(chore_usual.title)
     expect(page).to have_content(chore_other_context.title)
     expect(page).to have_no_content(chore_other_type.title)
 
     expect(page).to have_content(other_choretype.name)
     visit chores_path(:context => @context.id, :choretype =>other_choretype.id)   

     expect(page).to have_no_content(chore_usual.title)
     expect(page).to have_no_content(chore_other_context.title)
     expect(page).to have_content(chore_other_type.title)
     
   
      
    end
  end

   
   describe "after there are some chores" do
    it "should be able to show it" do
     chore = FactoryGirl.create(:chore, project_id: @project.id, email_id: @email.id, choretype_id: @choretype.id, user_id: @user.id)

     visit chores_path
     expect(page).to have_content(chore.title)
     click_link("Show")
     
     expect(page).to have_content('Title: '+chore.title)
     expect(page).to have_content(@email.subject)
     expect(page).to have_content(@choretype.name)
     expect(page).to have_content(@project.title)

    end
   end
   
    it "should be able to edit it" do
     chore = FactoryGirl.create(:chore, project_id: @project.id, email_id: @email.id, choretype_id: @choretype.id, user_id: @user.id)

     new_project = FactoryGirl.create(:project, context_id: @context.id, user_id: @user.id)

     visit chores_path
     expect(page).to have_content(chore.title)
     click_link("Edit", :href =>"/chores/"+chore.id.to_s+"/edit")
   
     expect(find_field('chore_title').value).to  eq chore.title
     expect(page).to have_select('chore[email_id]', :selected => @email.subject);
     expect(page).to have_select('chore[choretype_id]', :selected => @choretype.name);
     expect(page).to have_select('chore[project_id]', :selected => @project.title);

     new_title = "new title"
     fill_in('chore_title', :with => new_title)

     select(new_project.title,:from => 'chore[project_id]')

     click_button("Update Chore")
 
     expect(page).to have_content('Title: '+new_title)
     expect(page).to have_content('Project: '+new_project.title)

     visit chores_path

     expect(page).to have_content(new_title)
     expect(page).to have_content(new_project.title)
   end

   it "should be able to delete it" do
     chore = FactoryGirl.create(:chore, project_id: @project.id, email_id: @email.id, choretype_id: @choretype.id, user_id: @user.id)

     visit chores_path
     expect(page).to have_content(chore.title)
     click_link("Destroy")
#     click_button("OK")

     expect(page).to have_no_content(chore.title)

   end

   
  end
end


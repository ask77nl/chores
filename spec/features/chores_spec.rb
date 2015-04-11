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
      fill_in('chore_deadline', :with => chore.deadline.to_s(:due_date))

#      print "filled in chore deadline: ",chore.deadline.to_s(:due_date),"\n"
      #puts page.body
      
        click_button('Create Chore')
  


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
     
     #puts "other context has project with id: "+Project.all_active_projects(other_context.id,@user.id ).first.id.to_s
     #puts "other context should display chore with project id: "+Chore.all_chores_by_context_type_and_user(other_context,@choretype, @user.id).first.project_id.to_s
     #puts "other context should display chores: "+Chore.all_chores_by_context_type_and_user(other_context,@choretype, @user.id).length.to_s
     
     
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

   describe "when there are nested projects" do
    it "all of them should be displayed in chore listing" do

    child_project = FactoryGirl.create(:project, context_id: @context.id, user_id: @user.id, parent_project_id: @project.id)
    
       
    child_project_chore = FactoryGirl.create(:chore, project_id: child_project.id, choretype_id: @choretype.id, user_id: @user.id)
   
    visit chores_path(:context => @context.id, :choretype =>@choretype.id)

     expect(page).to have_content(child_project_chore.title)
     expect(page).to have_content(@project.title+' > '+child_project.title)
      
    end
  end

  describe "when there are different types of chores and projects, ready to be displayed on status quo page" do
    it "all of them should be displayed on the status quo page" do
      
    chore = FactoryGirl.create(:chore, project_id: @project.id, email_id: @email.id, choretype_id: @choretype.id, user_id: @user.id)
    @choretype_appointment = 3
    todays_appointment = FactoryGirl.create(:chore, choretype_id: @choretype_appointment, project_id: @project.id, user_id: @user.id, startdate: Time.zone.now.to_date, schedule: nil)
    empty_project = FactoryGirl.create(:project, context_id: @context.id, user_id: @user.id)
   
    wrong_context = FactoryGirl.create(:context, user_id: @user.id)
    wrong_project = FactoryGirl.create(:project, context_id: wrong_context.id, user_id: @user.id)
    wrong_chore =  FactoryGirl.create(:chore, project_id: wrong_project.id, email_id: @email.id, choretype_id: @choretype.id, user_id: @user.id)
    wrong_empty_project = FactoryGirl.create(:project, context_id: wrong_context.id, user_id: @user.id)
    wrong_todays_appointment = FactoryGirl.create(:chore, choretype_id: @choretype_appointment, project_id: wrong_project.id, user_id: @user.id, startdate: Time.zone.now.to_date, schedule: nil)
      
    visit status_quo_chores_path(:context => @context.id)

     expect(page).to have_content(chore.title)
     expect(page).to have_content(@project.title)
     expect(page).to have_content(empty_project.title)
     expect(page).to have_content(todays_appointment.title)
     
     expect(page).to have_no_content(wrong_chore.title)
     expect(page).to have_no_content(wrong_project.title)
     expect(page).to have_no_content(wrong_empty_project.title)
     expect(page).to have_no_content(wrong_todays_appointment.title)
     
     
      
    end
  end
  
   
    it "should be able to edit it" do
     chore = FactoryGirl.create(:chore, project_id: @project.id, email_id: @email.id, choretype_id: @choretype.id, user_id: @user.id)

     new_project = FactoryGirl.create(:project, context_id: @context.id, user_id: @user.id)

     visit chores_path
     expect(page).to have_content(chore.title)
     click_link(chore.title, :href =>"/chores/"+chore.id.to_s+"/edit")
   
     expect(find_field('chore_title').value).to  eq chore.title
     expect(page).to have_select('chore[email_id]', :selected => @email.subject);
     expect(page).to have_select('chore[choretype_id]', :selected => @choretype.name);
     expect(page).to have_select('chore[project_id]', :options => [@project.title, new_project.title]);
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
   
    it "if the project is marked as Someday, the chore should disappear" do
     chore = FactoryGirl.create(:chore, project_id: @project.id, email_id: @email.id, choretype_id: @choretype.id, user_id: @user.id)

     visit projects_path
     
     edit_url = "/projects/"+@project.id.to_s+"/edit"
     edit_anchor = "//a[@href='"+edit_url+"']"
     find(:xpath, edit_anchor).click
   
     find(:css, "#project_someday").set(true)
     click_button("Update Project")
     
      
     visit chores_path
     expect(page).not_to have_content(chore.title)
     
   end

   it "should be able to delete it" do
     chore = FactoryGirl.create(:chore, project_id: @project.id, email_id: @email.id, choretype_id: @choretype.id, user_id: @user.id)

     visit chores_path
     expect(page).to have_content(chore.title)
     click_link("Delete")
#     click_button("OK")

     expect(page).to have_no_content(chore.title)

   end

   
  end
end


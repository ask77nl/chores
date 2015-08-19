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

  describe "when we are editing chore" do
    
    self.use_transactional_fixtures = false
    
    it "dates and times fields should only be visible when we enable them", :js => true do
     
     choretype_appointment = FactoryGirl.create(:choretype, id: 3)  
     visit new_chore_path()
     
     expect(page).to have_select('chore[choretype_id]', :selected => @choretype.name);
     expect(page).to have_css('input[type="text"][name*="chore[startdate]"]', visible: false)
     expect(page).to have_css('input[type="text"][name*="chore[deadline]"]', visible: false)
     
     select(choretype_appointment.name, :from => 'chore_choretype_id')   
     
     expect(page).to have_css('input[type="text"][name*="chore[startdate]"]', visible: true)
     expect(page).to have_css('input[type="text"][name*="chore[deadline]"]', visible: true)

     expect(find_field('chore[startdate]').value).to eq(Time.now.strftime("%m/%d/%Y"))
     expect(find_field('chore[deadline]').value).to eq(Time.now.strftime("%m/%d/%Y"))

     
     all_day_box = find('#chore_all_day')
     expect(all_day_box).to be_checked 
     
     expect(page).to have_css('select[name*="start_time[time(4i)]"]', visible: false)
     expect(page).to have_css('select[name*="end_time[time(4i)]"]', visible: false)
     
     all_day_box.set(false)
     
     expect(page).to have_css('select[name*="start_time[time(4i)]"]', visible: true)
     expect(page).to have_css('select[name*="end_time[time(4i)]"]', visible: true)
     
    end
  end
  
   describe "when we are editing project" do
    
    self.use_transactional_fixtures = false
    
    it "context must change depending on the parent project", :js => true do
     
     
     child_project = FactoryGirl.create(:project, context_id: @context.id, user_id: @user.id, parent_project_id: @project.id)
     second_context = FactoryGirl.create(:context, user_id: @user.id)
     second_parent_project =  FactoryGirl.create(:project, context_id: second_context.id, user_id: @user.id)
             
     visit projects_path()
     
     expect(page).to have_content(child_project.title)
     edit_url = "/projects/"+@project.id.to_s+"/edit"
     edit_anchor = "//a[@href='"+edit_url+"']"
     find(:xpath, edit_anchor).click
     
     expect(page).to have_select('project[context_id]', :selected => @context.name)
     
     select(second_parent_project.title, :from => 'project[parent_project_id]')   
     
     expect(page).to have_select('project[context_id]', :selected => second_context.name)
     
    end
  end
  
  end
end


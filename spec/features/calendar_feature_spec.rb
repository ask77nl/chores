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

  describe "when there are different types of chores to be done today" do
    
    self.use_transactional_fixtures = false
    
    it "all of them should be displayed on calendar view of chores", :js => true do
     

     @choretype_appointment = 3
      daily_chore = FactoryGirl.create(:chore, project_id: @project.id, email_id: @email.id, choretype_id: @choretype_appointment, user_id: @user.id)
      todays_chore = FactoryGirl.create(:chore, project_id: @project.id, email_id: @email.id, choretype_id: @choretype_appointment, user_id: @user.id, startdate:Time.zone.now.to_date, deadline: Time.zone.now.to_date, schedule: nil )
      next_year_chore = FactoryGirl.create(:chore, project_id: @project.id, email_id: @email.id, choretype_id: @choretype_appointment, user_id: @user.id, startdate:Time.zone.now.to_date+365, deadline: Time.zone.now.to_date+365, schedule: nil)
      
     visit calendar_chores_path()

     expect(page).to have_css("span",:text => daily_chore.title, :count =>7)
     expect(page).to have_css("span",:text => todays_chore.title, :count =>1)
     expect(page).to have_css("span",:text => next_year_chore.title, :count =>0)
    end
  end
  
  
  end
end


require 'spec_helper'


describe Chore do

 before {
    @context = FactoryGirl.create(:context) 
    @project = FactoryGirl.create(:project, context_id: @context.id)
    @user = FactoryGirl.create(:user)
    @choretype = FactoryGirl.create(:choretype)
    @email = FactoryGirl.create(:email)
    @chore = FactoryGirl.create(:chore,project_id: @project.id,choretype_id: @choretype.id, email_id: @email.id ,user_id: @user.id) 
   }
 
 subject { @chore }

 it {
  should respond_to(:title) 
  should respond_to(:project_id)
  should respond_to(:choretype_id) 
  should respond_to(:email_id)
  should respond_to(:user_id)
  should respond_to(:schedule)
}

 describe "when title  is not present" do
    before { @chore.title = "" }
    it { should_not be_valid }
 end

 describe "when project is not present" do
    before { @chore.project_id = "" }
    it { should_not be_valid }
 end

describe "when type is not present" do
    before { @chore.choretype_id = "" }
    it { should_not be_valid }
 end

describe "when user_id is not present" do
    before { @chore.user_id = "" }
    it { should_not be_valid }
 end
 
describe "when requesting it's project via getter" do
   
    it "it should return the correct project object" do
      expect(@chore.project).to eq @project
    end
 end

describe "when requesting all chores by context and user" do
 it "should not show chores from a wrong user" do
   FactoryGirl.create(:chore, choretype_id: @choretype.id, project_id: @project.id, user_id: 666)
   expect(Chore.all_chores_by_context_type_and_user(@context.id,@choretype.id,@user.id)).to eq([@chore]) 
  end
 it "should not show chores from a wrong project" do
   FactoryGirl.create(:chore,choretype_id: @choretype.id, project_id: 666 ,user_id: @user.id)
   expect(Chore.all_chores_by_context_type_and_user(@context.id,@choretype.id,@user.id)).to eq([@chore]) 
  end
  it "should not show chores from a wrong choretype" do
   FactoryGirl.create(:chore,choretype_id: 666, project_id: @project.id ,user_id: @user.id)
   expect(Chore.all_chores_by_context_type_and_user(@context.id,@choretype.id,@user.id)).to eq([@chore]) 
  end
  it "should not show chores from someday projects" do
   someday_project = FactoryGirl.create(:project, context_id: @context.id, someday: true)
   FactoryGirl.create(:chore,choretype_id: @choretype.id, project_id: someday_project.id ,user_id: @user.id)
   expect(Chore.all_chores_by_context_type_and_user(@context.id,@choretype.id,@user.id)).to eq([@chore]) 
  end
end

describe "when requesting all active chores " do
 it "should not show chores with start date in the future" do
   FactoryGirl.create(:chore, choretype_id: @choretype.id, project_id: @project.id, user_id: @user.id, startdate: Time.zone.now.to_date+2.days)
   expect(Chore.all_active_chores(@context.id,@choretype.id,@user.id)).to eq([@chore]) 
  end
end

describe "when requesting all today and missed appointments" do
  before do
   @choretype_appointment = 3
  end
 it "should show today's appointments" do
   todays_appointment = FactoryGirl.create(:chore, choretype_id: @choretype_appointment, project_id: @project.id, user_id: @user.id, startdate: Time.zone.now.to_date, schedule: nil)
   expect(Chore.all_today_and_missed_appointments(@context.id,@choretype_appointment,@user.id)).to eq([todays_appointment]) 
  end
 it "should show missed appointments" do
   yesterday_appointment = FactoryGirl.create(:chore, choretype_id: @choretype_appointment, project_id: @project.id, user_id: @user.id, startdate: Time.zone.now.to_date - 1.day, schedule: nil)
   expect(Chore.all_today_and_missed_appointments(@context.id,@choretype_appointment,@user.id)).to eq([yesterday_appointment]) 
  end
  
  it "should not show future appointments" do
   FactoryGirl.create(:chore, choretype_id: @choretype_appointment, project_id: @project.id, user_id: @user.id, startdate: Time.zone.now.to_date + 3.days, schedule: nil)
   expect(Chore.all_today_and_missed_appointments(@context.id,@choretype_appointment,@user.id)).to eq([]) 
  end
  
  it "should show appointments, that occur today" do
   schedule_today = IceCube::Schedule.new(Time.zone.now)
   schedule_today.add_recurrence_rule IceCube::Rule.weekly.day(Time.zone.now.wday)
   appointment_occurs_today = FactoryGirl.create(:chore, choretype_id: @choretype_appointment, project_id: @project.id, user_id: @user.id, schedule: IceCube::Rule.weekly.day(Time.zone.now.wday).to_json.to_s)
   expect(Chore.all_today_and_missed_appointments(@context.id,@choretype_appointment,@user.id)).to eq([appointment_occurs_today]) 
  end
  
  it "should not show appointments, that occur tomorrow" do
   schedule_today = IceCube::Schedule.new(Time.zone.now)
   schedule_today.add_recurrence_rule IceCube::Rule.weekly.day(Time.zone.now.wday+1)
   appointment_occurs_today = FactoryGirl.create(:chore, choretype_id: @choretype_appointment, project_id: @project.id, user_id: @user.id, schedule: IceCube::Rule.weekly.day(Time.zone.now.wday+1).to_json.to_s)
   expect(Chore.all_today_and_missed_appointments(@context.id,@choretype_appointment,@user.id)).to eq([]) 
  end
end
   
end

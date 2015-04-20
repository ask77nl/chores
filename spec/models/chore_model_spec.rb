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
 it "should not show chores that are not a next action" do
   FactoryGirl.create(:chore, choretype_id: @choretype.id, project_id: @project.id, user_id: @user.id, next_action: false)
   expect(Chore.all_active_chores(@context.id,@choretype.id,@user.id)).to eq([@chore]) 
  end
end

describe "when deleting a last next action" do
  it "all other actions become next ones" do
   not_a_next_action = FactoryGirl.create(:chore, choretype_id: @choretype.id, project_id: @project.id, user_id: @user.id, next_action: false) 
   expect(Chore.all_active_chores(@context.id,@choretype.id,@user.id)).to eq([@chore]) 
   Chore.destroy(@chore.id)
   not_a_next_action = Chore.find(not_a_next_action.id)
   expect(not_a_next_action.next_action).to eq(true)
   expect(Chore.all_active_chores(@context.id,@choretype.id,@user.id)).to eq([not_a_next_action]) 
  end
end

describe "when requesting all appointment occurrences for today  " do
 it "should return an occurrence of a daily appointment" do
   @choretype_appointment = 3
   
   todays_chore = FactoryGirl.create(:chore, project_id: @project.id, email_id: @email.id, choretype_id: @choretype_appointment, user_id: @user.id, startdate:Time.zone.now.to_date, deadline: Time.zone.now.to_date)
   daily_chore = FactoryGirl.create(:chore, project_id: @project.id, email_id: @email.id, choretype_id: @choretype_appointment, user_id: @user.id)
   
   occurrence1 = {:id=>todays_chore.id,:title=>todays_chore.title,:start=>Time.zone.now.to_date.strftime("%Y-%m-%d 00:00:00 -0400"),:end=>Time.zone.now.to_date.strftime("%Y-%m-%d 00:00:00 -0400"),:url=>"/chores/"+todays_chore.id.to_s+"/edit", :allDay=>true}
   occurrence2 = {:id=>daily_chore.id,:title=>daily_chore.title,:start=>Time.zone.now.to_date.strftime("%Y-%m-%d 00:00:00 -0400"),:end=>Time.zone.now.to_date.strftime("%Y-%m-%d 00:00:00 -0400"),:url=>"/chores/"+daily_chore.id.to_s+"/edit", :allDay=>true}
   
   expect(Chore.appointment_occurrences(@context,Time.zone.now.to_date,Time.zone.now.to_date, @user.id)).to eq([occurrence1, occurrence2])   
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
   FactoryGirl.create(:chore, choretype_id: @choretype_appointment, project_id: @project.id, user_id: @user.id, startdate: Time.zone.now + 3.days,deadline:Time.zone.now + 3.days, schedule: nil)
   expect(Chore.all_today_and_missed_appointments(@context.id,@choretype_appointment,@user.id)).to eq(nil) 
  end
  
  it "should show appointments, that occur today" do
   schedule_today = IceCube::Schedule.new(Time.zone.now)
   schedule_today.add_recurrence_rule IceCube::Rule.weekly.day(Time.zone.now.wday)
   appointment_occurs_today = FactoryGirl.create(:chore, choretype_id: @choretype_appointment, project_id: @project.id, user_id: @user.id, schedule: IceCube::Rule.weekly.day(Time.zone.now.wday).to_json.to_s)
   expect(Chore.all_today_and_missed_appointments(@context.id,@choretype_appointment,@user.id)).to eq([appointment_occurs_today]) 
  end
  
  it "should not show appointments, that occur tomorrow" do
   schedule_today = IceCube::Schedule.new(Time.zone.now)
   schedule_today.add_recurrence_rule IceCube::Rule.weekly.day((Time.zone.now.wday+1)%7)
   appointment_occurs_today = FactoryGirl.create(:chore, choretype_id: @choretype_appointment, project_id: @project.id, user_id: @user.id, startdate: Time.zone.now+1.day, deadline: Time.zone.now+1.day, schedule: IceCube::Rule.weekly.day((Time.zone.now.wday+1)%7).to_json.to_s)
   expect(Chore.all_today_and_missed_appointments(@context.id,@choretype_appointment,@user.id)).to eq(nil) 
  end
end

  describe "when calling move_start_date_to_next_occurrence on a chore" do
    before do
     @choretype_appointment = 3
    end
  
    it "should change the start date correctly" do
     appointment_occurs_today = FactoryGirl.create(:chore, choretype_id: @choretype_appointment, project_id: @project.id, user_id: @user.id, startdate: Time.zone.now, deadline: Time.zone.now, schedule: IceCube::Rule.weekly.day(Time.zone.now.wday).to_json.to_s)
     new_time = Time.zone.now
     new_time += 1.week
     expect(appointment_occurs_today.move_start_date_to_next_occurrence.to_i).to eq(new_time.to_i)

     appointment_occurs_today = Chore.find(appointment_occurs_today.id)
     expect(appointment_occurs_today.startdate.to_i).to eq(new_time.to_i) 
    end
  end
   
end

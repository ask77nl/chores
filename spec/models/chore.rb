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
   
end

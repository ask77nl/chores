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

describe "when searching for chores" do
 it "should properly filter them" do
   wrong_user_chore = FactoryGirl.create(:chore, choretype_id: @choretype.id, project_id: @project.id, user_id: 666)
   wrong_project_chore = FactoryGirl.create(:chore,choretype_id: @choretype.id, project_id: 666 ,user_id: @user.id)
   wrong_type_chore = FactoryGirl.create(:chore,choretype_id: 666, project_id: @project.id ,user_id: @user.id)
  
   expect(Chore.all_chores_by_context_type_and_user(@context.id,@choretype.id,@user.id)).to eq([@chore]) 
  end
end
   
end

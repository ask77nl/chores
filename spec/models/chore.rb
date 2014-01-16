require 'spec_helper'


describe Chore do

 before { 
    @project = FactoryGirl.build(:project)
    @user = FactoryGirl.build(:user)
    @choretype = FactoryGirl.build(:choretype)
    @email = FactoryGirl.build(:email)
    @chore = Chore.new(:title => "Chore1", :project_id => @project.id, :choretype_id => @choretype.id, :email_id => @email.id ,:user_id = @user.id) 
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


end

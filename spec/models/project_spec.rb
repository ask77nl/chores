require 'spec_helper'


describe Project do

 before { 
    @context = FactoryGirl.build(:context)
    @user = FactoryGirl.build(:user)
    @parent_project = FactoryGirl.build(:project)
    
    @project = Project.new(:title => "Project2", :context_id => @context.id, :parent_project_id => @parent_project.id, :user_id => @user.id) 
   }
 
 subject { @project }

 it {
  should respond_to(:title) 
  should respond_to(:context_id)
  should respond_to(:parent_project_id) 
  should respond_to(:user_id)

}

 describe "when title  is not present" do
    before { @project.title = "" }
    it { should_not be_valid }
 end

 describe "when context is not present" do
    before { @project.context_id = "" }
    it { should_not be_valid }
 end

 describe "when user is not present" do
    before { @project.user_id = "" }
    it { should_not be_valid }
 end





end

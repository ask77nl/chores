require 'spec_helper'


describe Project do

 before { 
    @context = FactoryGirl.create(:context)
    @user = FactoryGirl.create(:user)
    @parent_project = FactoryGirl.create(:project)
    @project = Project.create(:title => "Project2", :context_id => @context.id, :parent_project_id => @parent_project.id, :user_id => @user.id) 
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

  describe "When we have both active and inactive projects" do
    before {@someday_project = Project.create(:title => "Someday Title", :context_id => @context.id, :user_id => @user.id, :someday => true)}
    it "all_active_projects should return only active ones" do
      expect(Project.all_active_projects(@context.id, @user.id)).to eq([@project])
    end
    it "all_someday_projects should return only active ones" do
      expect(Project.all_someday_projects(@context.id, @user.id)).to eq([@someday_project])
    end
 end
 
  describe "When we move project to someday" do
    it "parent project should be nil" do
      @project.someday = true
      @project.parent_project_id = @parent_project.id
      @project.save
      @project = Project.find(@project.id)
      expect(@project.parent_project_id).to eq(nil)
    end
    
 end




end

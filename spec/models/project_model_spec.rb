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
    
  describe "When we have projects without chores" do
    before do
      @chore = FactoryGirl.create(:chore,project_id: @project.id, user_id: @user.id) 
      @empty_project = FactoryGirl.create(:project, title: "Empty Title", context_id: @context.id, user_id: @user.id, someday: false)
    end
    it "only they should be returned by empty_active_projects" do
     expect(Project.empty_active_projects(@context.id, @user.id)).to eq([@empty_project])
    end
 end
 
  describe "When we update the context on parent project" do
    before do
      
      @child_project = Project.create(:title => "Someday Title",:parent_project_id => @project.id, :context_id => @context.id, :user_id => @user.id)
      @project.reload
      @another_context =FactoryGirl.create(:context)
      #puts "project id is "+@project.id.to_s
      #puts "child project  id is "+@child_project.id.to_s
      #puts "child parent project id is "+@child_project.parent_project_id.to_s
    end
    it "The children should get the context updated too" do
      @project.update!(context_id:@another_context.id)
      
      @child_project = Project.find(@child_project.id)
      @project = Project.find(@project.id)
      #puts "projects context is now "+@project.context_id.to_s
      expect(@child_project.context_id).to eq(@another_context.id)
    end
 end

 describe "When we delete a project" do
    before do
      @medium_project = FactoryGirl.create(:project, :parent_project_id => @project.id, :context_id => @context.id, :user_id => @user.id)
      @bottom_project =  FactoryGirl.create(:project, :parent_project_id => @medium_project.id, :context_id => @context.id, :user_id => @user.id)
      @project.reload
      @medium_project.reload
      @bottom_project.reload
   
      @medium_chore = FactoryGirl.create(:chore, :project_id => @medium_project.id)

    end
    it "The children projects should be promoted and chores became orphan" do
      @medium_project.delete

      @bottom_project = Project.find(@bottom_project.id)
      @medium_chore = Chore.find(@medium_chore.id)

      expect(@bottom_project.parent_project_id).to eq(@project.id)
      expect(@medium_chore.project_id).to eq(nil)
    end
 end


end

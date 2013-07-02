require 'spec_helper'


describe Project do

 before { 
    @context = FactoryGirl.build(:context)
    @parent_project = FactoryGirl.build(:project)
    @project = Project.new(:title => "Project2", :context_id => @context.id, :parent_project_id => @parent_project.id) 
   }
 
 subject { @project }

 it {
  should respond_to(:title) 
  should respond_to(:context_id)
  should respond_to(:parent_project_id) 

}

 describe "when title  is not present" do
    before { @project.title = "" }
    it { should_not be_valid }
 end

 describe "when title or context is not present" do
    before { @project.context_id = "" }
    it { should_not be_valid }
 end




end

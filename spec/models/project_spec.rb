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

end

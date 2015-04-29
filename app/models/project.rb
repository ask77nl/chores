class Project < ActiveRecord::Base
  acts_as_nested_set :parent_column => :parent_project_id
  include TheSortableTree::Scopes
  
  attr_accessible :context_id, :parent_project_id, :title, :user_id, :comments, :someday
  has_many :chores
  belongs_to  :context
  belongs_to :user

  belongs_to :parent, :class_name => "Project", :foreign_key => :parent_project_id
  has_many :children, :class_name => "Project", :foreign_key => :project_id

  validates(:title, presence: true)
  validates(:context_id, presence: true)
  validates(:user_id, presence: true)
  
  def self.all_active_projects(context_id,user_id)
    if context_id == nil
      context_id = Context.first.id if Context.first
    end
   
    #@all_projects = Project.where(:context_id => context_id, :user_id =>user_id, :someday => false)
    #temporary show all Projects from all contexts
    @all_projects = Project.nested_set.select('*').where(:user_id =>user_id, :someday => false)
    #@all_projects = Project.nested_set.select('*').where(:context_id => context_id, :user_id =>user_id, :someday => false)
    return @all_projects
  end
  
  def self.empty_active_projects(context_id,user_id)
    if context_id == nil
      context_id = Context.first.id
    end
    @empty_projects = Project.nested_set.leaves.joins("LEFT OUTER JOIN chores on projects.id = chores.project_id").where({projects: {context_id: context_id,user_id: user_id, someday: false}, chores: {id: nil}}).order("projects.lft asc")
    
    if @empty_projects.length > 0 
      return @empty_projects
    else
      return nil
    end
  end
  
  def self.all_someday_projects(context_id,user_id)
    if context_id == nil
      context_id = Context.first.id
    end
   
    @all_projects = Project.nested_set.select('*').where(:context_id => context_id, :user_id =>user_id, :someday => true)
    return @all_projects
  end

  def parent_project_id=(parent_project_id)
    #if projects was put to someday list, it must be brought to root level
     #puts "launching setter"
    if(self.someday)
      #self.move_to_root
      write_attribute(:parent_project_id, nil)
      #puts "moving project with title="+self.title.to_s+" to root!"
    else
      write_attribute(:parent_project_id, parent_project_id)
    end
  end
  
  def context_id=(context_id)
    #if projects was children, they must all get the same id
    
    children_projects = self.descendants
    #puts "launching setter for project "+ self.id.to_s+", "+children_projects.length.to_s+" children found"
    
    children_projects.each do |project|
      project.update!(context_id: context_id)
     # puts "updating project "+project.id.to_s+" with context"+ context_id.to_s
    end
    write_attribute(:context_id, context_id)
    
  end

  def delete
    children_projects = self.descendants
    children_projects.each do |project|
      project.update!(parent_project_id: self.parent_project_id)
    end 
    Chore.where(:project_id => self.id).update_all(:project_id => nil)
    self.destroy
  end
end

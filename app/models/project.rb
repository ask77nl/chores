class Project < ActiveRecord::Base
  attr_accessible :context_id, :parent_project_id, :title
  has_many :chores
  belongs_to  :context


  belongs_to :parent, :class_name => "Project", :foreign_key => :parent_project_id
  has_many :children, :class_name => "Project", :foreign_key => :project_id

end

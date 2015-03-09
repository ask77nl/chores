class Project < ActiveRecord::Base
  acts_as_nested_set :parent_column => :parent_project_id
  include TheSortableTree::Scopes
  
  attr_accessible :context_id, :parent_project_id, :title, :user_id
  has_many :chores
  belongs_to  :context
  belongs_to :user

  belongs_to :parent, :class_name => "Project", :foreign_key => :parent_project_id
  has_many :children, :class_name => "Project", :foreign_key => :project_id

  validates(:title, presence: true)
  validates(:context_id, presence: true)
  validates(:user_id, presence: true)

end

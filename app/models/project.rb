class Project < ActiveRecord::Base
  attr_accessible :context_id, :parent_project_id, :title
  has_many :chores
end

class MakeProjectsNestedSet < ActiveRecord::Migration
  def change
   add_column :projects, :lft, :integer, :null => false, :index => true, :default => 0
   add_column :projects, :rgt, :integer, :null => false, :index => true, :default => 0
   change_column :projects, :parent_project_id, :integer, :null => true, :index => true
  end
end

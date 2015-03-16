class AddCommentsAndSomedayToProjects < ActiveRecord::Migration
  def change
	add_column :projects, :comments, :text
	add_column :projects, :someday, :boolean
  end
end

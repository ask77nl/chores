class MakeSomedayMandatoryFalse < ActiveRecord::Migration
  def change
	Project.update_all(:someday => false)
	change_column :projects, :someday,:boolean, :null => false, :default => false
  end
end

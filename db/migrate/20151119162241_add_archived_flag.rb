class AddArchivedFlag < ActiveRecord::Migration
  def change
    add_column :chores, :archived, :boolean, default: false
    add_column :projects, :archived, :boolean, default: false
  end
end

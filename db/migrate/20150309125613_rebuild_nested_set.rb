class RebuildNestedSet < ActiveRecord::Migration
  def change
   Project.where(parent_project_id: 0).update_all(parent_project_id: nil)

   Project.rebuild!
  end
end

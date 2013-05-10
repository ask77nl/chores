class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :context_id
      t.string :title
      t.integer :parent_project_id

      t.timestamps
    end
  end
end

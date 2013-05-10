class CreateChores < ActiveRecord::Migration
  def change
    create_table :chores do |t|
      t.integer :email_id
      t.string :title
      t.datetime :deadline
      t.integer :type
      t.integer :project_id

      t.timestamps
    end
  end
end

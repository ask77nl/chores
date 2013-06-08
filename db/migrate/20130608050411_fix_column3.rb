class FixColumn3 < ActiveRecord::Migration
  def up
  end

  def down
  end

 def change
   rename_column :chores, :chore_type, :choretype_id
  end

end

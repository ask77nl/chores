class FixColumnName2 < ActiveRecord::Migration
  def up
  end

  def down
  end

  def create
   rename_column :chore, :chore_type, :choretype_id
  end
end

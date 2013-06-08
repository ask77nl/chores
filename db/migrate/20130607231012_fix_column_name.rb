class FixColumnName < ActiveRecord::Migration
  def up
  end

  def down
  end

  def change
    rename_column :chores, :type, :chore_type
  end
end

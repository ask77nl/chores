class MakeNextActionTrue < ActiveRecord::Migration
  def change
   Chore.update_all(:next_action => true)
   change_column :chores, :next_action, :boolean, :default => true
  end
end

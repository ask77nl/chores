class AddAllDayAndNextActionBoolean < ActiveRecord::Migration
  def change
   add_column :chores, :all_day, :boolean, :default => true
   add_column :chores, :next_action, :boolean, :default => false
  end
end

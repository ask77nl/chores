class AddSchedule < ActiveRecord::Migration
  def change 
    add_column :chores, :schedule, :text
  end
end

class AddUserId < ActiveRecord::Migration
  def change 
     add_column :chores, :user_id, :integer
     add_column :contexts, :user_id, :integer
     add_column :emails, :user_id, :integer
     add_column :projects, :user_id, :integer
  end

end

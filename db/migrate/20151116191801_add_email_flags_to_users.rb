class AddEmailFlagsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :unread_inbox_emails, :boolean, default: false
    add_column :users, :total_inbox_emails, :boolean, default: false
    add_column :users, :unread_project_emails, :boolean, default: false
  end
end

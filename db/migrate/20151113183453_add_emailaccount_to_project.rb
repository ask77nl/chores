class AddEmailaccountToProject < ActiveRecord::Migration
  def change
    add_column :projects, :email_address, :text
  end
end

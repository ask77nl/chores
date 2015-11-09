class AddEmailAccountsTable < ActiveRecord::Migration
  def change
    create_table :emailaccounts do |t|
      t.string :email_address
      t.text :authentication_token
      t.integer :user_id
    end
   end
end

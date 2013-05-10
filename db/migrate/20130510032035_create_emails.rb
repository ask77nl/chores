class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :from
      t.string :to
      t.datetime :datetime
      t.string :subject
      t.string :body

      t.timestamps
    end
  end
end

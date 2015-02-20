class AddStartDate < ActiveRecord::Migration
  def change
    add_column :chores, :startdate, :datetime
  end
end

class UnarchiveAllItems < ActiveRecord::Migration
  def change
    Chore.update_all(:archived => false)
    Project.update_all(:archived => false)
  end
end

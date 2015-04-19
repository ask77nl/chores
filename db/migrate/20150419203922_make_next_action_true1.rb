class MakeNextActionTrue1 < ActiveRecord::Migration
  def change
      Chore.update_all(:next_action => true)
  end
end

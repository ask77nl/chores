class SetAllSchedulestoNil < ActiveRecord::Migration
  def change
     Chore.update_all(:schedule => nil)
  end
end

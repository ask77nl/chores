class AddThreadIdToProject < ActiveRecord::Migration
  def change
    add_column :projects, :thread_id, :text
  end
end

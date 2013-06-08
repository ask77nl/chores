class CreateChoretypes < ActiveRecord::Migration
  def change
    create_table :choretypes do |t|
      t.string :name

      t.timestamps
    end

    Choretype.create :name => "TODO"
    Choretype.create :name => "Waiting"
    Choretype.create :name => "Appointment"

  end
end

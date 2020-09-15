class CreateSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :schedules do |t|
      t.string :name, null: false
      t.datetime :start
      t.datetime :end
      t.datetime :shift_start
      t.datetime :shift_end
      t.integer :frequency
      t.references :project, null: false
      t.timestamps
    end
  end
end

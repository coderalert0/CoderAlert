class CreateScheduleUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :schedule_users do |t|
      t.integer :priority, null: false
      t.references :schedule, null: false
      t.references :user, null: false
      t.timestamps
    end
  end
end

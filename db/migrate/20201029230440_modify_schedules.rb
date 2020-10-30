class ModifySchedules < ActiveRecord::Migration[5.2]
  def change
    remove_column :schedules, :start, :datetime
    remove_column :schedules, :end, :datetime
    remove_column :schedules, :shift_start, :datetime
    remove_column :schedules, :shift_end, :datetime
    remove_column :schedules, :frequency, :integer
    add_column :schedules, :rule, :string
  end
end

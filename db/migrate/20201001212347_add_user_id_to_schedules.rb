class AddUserIdToSchedules < ActiveRecord::Migration[5.2]
  def change
    add_reference :schedules, :user, null: false
  end
end

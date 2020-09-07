class AddMissingTimestamps < ActiveRecord::Migration[5.2]
  def change
    add_timestamps :articles, null: true
    add_timestamps :companies, null: true
    add_timestamps :project_users, null: true
    add_timestamps :projects, null: true
    add_timestamps :tickets, null: true
  end
end

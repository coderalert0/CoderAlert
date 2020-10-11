class AddRoleToProjectUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :project_users, :admin, :boolean, default: false
    add_column :users, :global_admin, :boolean, default: false
  end
end

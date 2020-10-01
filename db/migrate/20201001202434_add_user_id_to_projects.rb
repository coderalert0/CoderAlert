class AddUserIdToProjects < ActiveRecord::Migration[5.2]
  def change
    add_reference :projects, :user, null: false
  end
end

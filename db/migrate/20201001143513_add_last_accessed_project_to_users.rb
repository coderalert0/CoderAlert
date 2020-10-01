class AddLastAccessedProjectToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :last_accessed_project, foreign_key: { to_table: :projects }
  end
end

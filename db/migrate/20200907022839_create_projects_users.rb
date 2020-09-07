class CreateProjectsUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :project_users do |t|
      t.references :project, null: false
      t.references :user, null: false
    end
  end
end

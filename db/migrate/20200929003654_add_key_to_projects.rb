class AddKeyToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :slug, :string
    add_column :projects, :key, :string, null: false

    add_index :projects, [:key, :company_id], unique: true
  end
end

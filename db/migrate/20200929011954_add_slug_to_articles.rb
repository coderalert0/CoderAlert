class AddSlugToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :slug, :string, null: false

    add_index :articles, [:slug, :project_id], unique: true
  end
end

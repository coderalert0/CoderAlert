class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.references :project, null: false
      t.references :user, null: false
    end
  end
end

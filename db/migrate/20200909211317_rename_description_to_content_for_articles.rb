class RenameDescriptionToContentForArticles < ActiveRecord::Migration[5.2]
  def change
    rename_column :articles, :description, :content
  end
end

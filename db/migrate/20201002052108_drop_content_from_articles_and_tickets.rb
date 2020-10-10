class DropContentFromArticlesAndTickets < ActiveRecord::Migration[5.2]
  def change
    remove_column :articles, :content, :string
    remove_column :tickets, :description, :string
  end
end

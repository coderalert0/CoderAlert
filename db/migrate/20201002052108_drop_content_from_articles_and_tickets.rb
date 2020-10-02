class DropContentFromArticlesAndTickets < ActiveRecord::Migration[5.2]
  def change
    remove_column :articles, :content
    remove_column :tickets, :description
  end
end

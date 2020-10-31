class AddPtoAndTitleToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :pto, :boolean, default: false
    add_column :users, :title, :string
  end
end

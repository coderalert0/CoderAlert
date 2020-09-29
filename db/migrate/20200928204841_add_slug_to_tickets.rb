class AddSlugToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :slug, :string, null: false
  end
end

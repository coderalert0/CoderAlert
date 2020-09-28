class AddSlugToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :slug, :string, unique: true
  end
end

class CreateTicketViews < ActiveRecord::Migration[5.2]
  def change
    create_table :ticket_views do |t|
      t.integer :count, default: 0
      t.references :ticket, null: false
      t.references :user, null: false
      t.timestamps
    end
  end
end

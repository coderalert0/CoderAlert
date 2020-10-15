class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.string :title, null: false
      t.integer :status, null: false
      t.integer :priority, null: false
      t.string :description, null: false
      t.references :created_by
      t.references :assignee
      t.references :project, null: false
    end
  end
end

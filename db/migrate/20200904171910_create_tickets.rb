class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.string :title, null: false
      t.string :status, null: false
      t.string :priority, null: false
      t.string :description, null: false
      t.references :created_by, null: false
      t.references :assignee
      t.references :project, null: false
    end
  end
end

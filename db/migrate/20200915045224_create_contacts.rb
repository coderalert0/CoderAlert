class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.string :type, null: false
      t.string :value, null: false
      t.references :user, null: false
    end
  end
end

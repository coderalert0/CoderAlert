class CreateAlertSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :alert_settings do |t|
      t.boolean :alert, default: false
      t.references :alertable, polymorphic: true, null: false
      t.references :user, null: false
      t.references :project, null: false
      t.timestamps
    end
  end
end

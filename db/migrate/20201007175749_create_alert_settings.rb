class CreateAlertSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :alert_settings do |t|
      t.string :alert
      t.references :alertable, polymorphic: true, null: false
      t.references :user, null: false
      t.string :slack_user_id
      t.string :slack_email
      t.references :project, null: false
      t.timestamps
    end
  end
end

class CreateAuthorizations < ActiveRecord::Migration[5.2]
  def change
    create_table :authorizations do |t|
      t.string :type, null: false
      t.string :access_token, null: false
      t.string :webhook_url
      t.string :name
      t.string :channel
      t.references :project, null: false
      t.references :user, null: false
      t.timestamps
    end
  end
end

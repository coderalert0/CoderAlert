class AddSlackUserIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :slack_user_id, :string
    add_column :tickets, :slack_channel_id, :string
  end
end

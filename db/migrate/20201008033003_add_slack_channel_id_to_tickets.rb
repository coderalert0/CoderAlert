class AddSlackChannelIdToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :slack_channel_id, :string
  end
end

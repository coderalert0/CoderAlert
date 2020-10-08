class SlackListener
  def on_ticket_created(ticket)
    client = Slack::Web::Client.new(token: ticket.project.slack_authorization.access_token)

    channel_name = "prod_support_#{ticket.slug}"
    response = client.conversations_create(name: channel_name, is_private: false)
    channel_id = response.channel.id

    ticket.update(slack_channel_id: channel_id)

    client.conversations_invite(channel: channel_id, users: user_list)
    client.chat_postMessage(channel: channel_name, text: ticket.decorate.slack_created_message)
  rescue StandardError => e
    Rails.logger.info e
  end

  def on_ticket_updated(ticket); end

  private

  def user_list
    ticket.project.users.with_slack_user_id.pluck(:slack_user_id).join(',')
  end
end

class SlackListener
  def on_ticket_created(ticket)
    client = Slack::Web::Client.new(token: Authorization.last.access_token)

    channel_name = "prod_support_#{ticket.slug}"
    response = client.conversations_create(name: channel_name, is_private: false)

    channel_id = response.channel.id
    client.conversations_invite(channel: channel_id, users: 'U01BNCUTU07') # replace hard-coded user id
    client.chat_postMessage(channel: channel_name, text: ticket.decorate.slack_created_message)
  end

  def on_ticket_updated(ticket); end
end

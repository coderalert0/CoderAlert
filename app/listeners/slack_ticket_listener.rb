class SlackTicketListener
  def on_ticket_created(ticket)
    client = Slack::Web::Client.new(token: ticket.project.slack_authorization.access_token)
    channel_id = create_channel(client, ticket)
    send_ticket_created_message(client, channel_id, ticket)
  end

  def on_ticket_updated(ticket)
    return if ticket.slack_channel_id.nil?

    client = Slack::Web::Client.new(token: ticket.project.slack_authorization.access_token)
    send_ticket_updated_message(client, ticket)
  end

  private

  def create_channel(client, ticket)
    channel_name = "prod_support_#{ticket.slug}"
    response = client.conversations_create(name: channel_name, is_private: false)
    channel_id = response.channel.id
    ticket.update_columns(slack_channel_id: channel_id)
    channel_id
  rescue StandardError => e
    Rails.logger.info e
  end

  def send_ticket_created_message(client, channel_id, ticket)
    client.conversations_invite(channel: channel_id, users: user_list(ticket))
    client.chat_postMessage(channel: channel_id, text: ticket.decorate.slack_created_message)
  rescue StandardError => e
    Rails.logger.info e
  end

  def send_ticket_updated_message(client, ticket)
    client.chat_postMessage(channel: ticket.slack_channel_id, text: ticket.decorate.slack_updated_message)
  rescue StandardError => e
    Rails.logger.info e
  end

  def user_list(ticket)
    ticket.project.slack_authorization.alert_settings.with_slack_user_id.pluck(:slack_user_id).join(',')
  end
end

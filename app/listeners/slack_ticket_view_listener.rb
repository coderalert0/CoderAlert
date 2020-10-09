class SlackTicketViewListener
  include Rails.application.routes.url_helpers

  def on_ticket_view_created(ticket_view)
    ticket = ticket_view.ticket

    return unless (ticket_view.user == ticket.assignee) && ticket.slack_channel_id.present?

    client = Slack::Web::Client.new(token: ticket.project.slack_authorization.access_token)

    send_ticket_viewed_message(client, ticket_view)
  end

  private

  def send_ticket_viewed_message(client, ticket_view)
    client.chat_postMessage(channel: ticket_view.ticket.slack_channel_id,
                            text: ticket_view.decorate.slack_ticket_viewed)
  rescue StandardError => e
    Rails.logger.info e
  end
end

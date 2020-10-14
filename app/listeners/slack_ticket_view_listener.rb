class SlackTicketViewListener
  def on_ticket_view_created(ticket_view)
    return unless ticket_view.user == ticket_view.ticket.assignee

    client = SlackClient.new(ticket_view: ticket_view)
    client.send_ticket_viewed_message
  end
end

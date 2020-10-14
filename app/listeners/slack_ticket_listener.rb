class SlackTicketListener
  def on_ticket_created(ticket)
    client(ticket).send_ticket_created_message
  end

  def on_ticket_updated(ticket)
    client(ticket).send_ticket_updated_message
  end

  def on_ticket_closed(ticket)
    client(ticket).archive_channel
  end
  alias on_ticket_cancelled on_ticket_closed

  private

  def client(ticket)
    SlackClient.new(ticket: ticket)
  end
end

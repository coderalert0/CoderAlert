class TicketListener
  def on_ticket_created(ticket)
    TicketMailer.with(ticket: ticket, changes: ticket.saved_changes.to_json).ticket_created.deliver_later
  end

  def on_ticket_updated(ticket)
    TicketMailer.with(ticket: ticket, changes: ticket.saved_changes.to_json).ticket_updated.deliver_later
  end
end

class TicketListener
  def on_ticket_created(ticket); end

  def on_ticket_updated(ticket, _block)
    TicketMailer.with(user: User.last.decorate, ticket: ticket).ticket_updated.deliver_now
  end

  def on_ticket_destroyed(ticket)
    TicketMailer.with(user: User.last.decorate, ticket: ticket).ticket_destroyed.deliver_now
  end
end

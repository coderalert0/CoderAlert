class TicketListener
  def on_ticket_created(ticket)
    TicketMailer.with(ticket: ticket, content: TicketMailerDecorator.decorate(ticket)
                                                   .created_content)
                .ticket_created
                .deliver_later
  end

  def on_ticket_updated(ticket)
    TicketMailer.with(ticket: ticket, content: TicketMailerDecorator
                                                   .decorate(ticket)
                                                   .updated_content)
                .ticket_updated
                .deliver_later
  end
end

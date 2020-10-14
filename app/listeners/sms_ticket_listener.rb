class SMSTicketListener
  def on_ticket_created(ticket)
    SmsClient.new(ticket).send_ticket_created_message
  end
end

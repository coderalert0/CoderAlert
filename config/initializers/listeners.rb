Rails.application.config.to_prepare do
  Wisper.clear if Rails.env.development? || Rails.env.test?

  Ticket.subscribe TicketListener.new, :prefix => true
end
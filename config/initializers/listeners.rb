Rails.application.config.to_prepare do
  Wisper.clear if Rails.env.development? || Rails.env.test?

  Ticket.subscribe TicketListener.new, :prefix => true
  Comment.subscribe CommentListener.new, :prefix => true
  Schedule.subscribe ScheduleListener.new, :prefix => true

  Ticket.subscribe SlackTicketListener.new, :prefix => true
  SlackAuthorization.subscribe SlackAuthorizationListener.new, :prefix => true
  Comment.subscribe SlackCommentListener.new, :prefix => true
end
class TicketMailer < ApplicationMailer
  before_action :load_resources

  def ticket_created
    mail(to: @ticket.assignee.email, subject: @ticket.created_subject)
  end

  def ticket_updated
    mail(to: @ticket.assignee.email, subject: @ticket.updated_subject)
  end

  private

  def load_resources
    @content = params[:content]
    @ticket =  MailTicketDecorator.decorate(params[:ticket])
  end
end

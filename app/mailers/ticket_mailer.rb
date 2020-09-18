class TicketMailer < ApplicationMailer
  before_action :load_resources

  def ticket_created
    mail(to: @ticket.assignee.email, subject: "#{@ticket.title} was created by #{@ticket.assignee.first_name}")
  end

  def ticket_updated
    mail(to: @ticket.assignee.email, subject: "#{@ticket.title} was updated by #{@ticket.assignee.first_name}")
  end

  private

  def load_resources
    @ticket = params[:ticket].decorate
    @changes = params[:changes]
  end
end

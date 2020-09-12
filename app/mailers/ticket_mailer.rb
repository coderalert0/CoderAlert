class TicketMailer < ApplicationMailer
  before_action :load_resources

  def ticket_created
    mail(to: @ticket.user.email, subject: "#{@ticket.title} was created by #{@ticket.user.full_name}")
  end

  def ticket_updated
    mail(to: @ticket.user.email, subject: "#{@ticket.title} was updated by #{@ticket.user.full_name}")
  end

  private

  def load_resources
    @ticket = params[:ticket].decorate
    @changes = params[:changes]
  end
end

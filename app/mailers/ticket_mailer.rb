class TicketMailer < ApplicationMailer
  def ticket_updated
    @user = params[:user]
    @ticket = params[:ticket]
    mail(to: @user.email, subject: "#{@ticket.title} was updated by #{@user.full_name}")
  end

  def ticket_destroyed
    @user = params[:user]
    @ticket = params[:ticket]
    mail(to: @user.email, subject: "#{@ticket.title} was deleted by #{@user.full_name}")
  end
end

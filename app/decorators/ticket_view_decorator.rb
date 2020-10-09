class TicketViewDecorator < ApplicationDecorator
  delegate_all
  decorates_association :user

  def slack_ticket_viewed
    "_Ticket viewed by #{slack_user_name} (assignee)_"
  end

  private

  def slack_user_name
    ticket.assignee.slack_user_id ? "<@#{ticket.assignee.slack_user_id}>" : ticket.assignee.full_name
  end
end

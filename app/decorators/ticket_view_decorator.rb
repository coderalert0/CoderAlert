class TicketViewDecorator < ApplicationDecorator
  delegate_all
  decorates_association :user

  def slack_ticket_viewed
    "_Ticket viewed by #{slack_user_name} (assignee)_"
  end

  private

  def slack_user_name
    alert_setting = AlertSetting.where(project: ticket.project,
                                       user: ticket.created_by,
                                       alertable: ticket.project.slack_authorization).first

    return unless alert_setting.present?

    alert_setting.slack_user_id ? "<@#{alert_setting.slack_user_id}>" : ticket.assignee.full_name
  end
end

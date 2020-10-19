class SlackTicketDecorator < TicketDecorator
  def ticket_created_message
    "<#{hostname}#{h.project_ticket_path(project, self)}|*[#{object.priority}] #{title}*>\n"\
    "```#{content.to_plain_text}```\n\n"\
    "_Ticket created by #{name(user, project)} and assigned to #{assignee_name}_\n"
  end

  def name(user, project)
    alert_setting = AlertSetting.where(project: project,
                                       user: user,
                                       alertable: project.slack_authorization).first

    return unless alert_setting.present?

    alert_setting.slack_user_id ? "<@#{alert_setting.slack_user_id}>" : user.full_name
  end

  def ticket_updated_message
    return unless saved_changes.present?

    "```#{updated_content}```\n\n_Ticket updated by #{name(user, project)}_\n"
  end

  def assignee_name
    return 'no one' if assignee.nil?

    name(assignee, project)
  end

  def comment_added
    "```#{content}```\n_Comment added by #{name(user, commentable.project)}_"
  end

  def ticket_viewed
    "_Ticket viewed by #{name(assignee, project)} (assignee)_"
  end
end

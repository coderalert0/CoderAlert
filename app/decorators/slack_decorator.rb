class SlackDecorator < ApplicationDecorator
  delegate_all

  def ticket_created_message
    "<#{hostname}#{h.project_ticket_path(project, self)}|*[#{object.priority}] #{title}*>\n"\
    "```#{content.to_plain_text}```\n\n"\
    "_Ticket created by #{name(created_by, project)} and assigned to #{assignee_name}_\n"
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

    "```#{ticket_changes}```\n\n_Ticket updated by #{name(created_by, project)}_\n"
  end

  def assignee_name
    return 'no one' if assignee.nil?

    name(assignee, project)
  end

  def comment_added
    "```#{content}```\n_Comment added by #{name(user, commentable.project)}_"
  end

  def ticket_viewed
    "_Ticket viewed by #{name(ticket.assignee, ticket.project)} (assignee)_"
  end

  # might be worth moving to a common class
  def hostname
    Rails.env.development? ? h.root_url(port: 3000).chomp!('/') : 'http://coderalert.com'
  end

  def ticket_changes
    formatted_changes = ''
    saved_changes.each do |attribute|
      next if attribute[0] == 'updated_at'

      if %w[status priority].include? attribute[0]
        attribute[1][0] = h.t(attribute[1][0].to_sym, scope: [:ticket, attribute[0].pluralize.to_sym])
        attribute[1][1] = h.t(attribute[1][1].to_sym, scope: [:ticket, attribute[0].pluralize.to_sym])
      end

      formatted_changes << "#{attribute[0].to_s.capitalize}: "\
                                    "Changed from #{attribute[1][0]}"\
                                    " to #{attribute[1][1]}\n"
    end
    formatted_changes
  end
end

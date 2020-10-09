class TicketDecorator < ApplicationDecorator
  delegate_all
  decorates_associations :assignee, :created_by

  def priority
    btn_class = {
      'Lowest' => 'btn-outline-dark',
      'Low' => 'btn-info',
      'Medium' => 'btn-secondary',
      'High' => 'btn-warning',
      'Highest' => 'btn-danger'
    }

    h.content_tag(:button, object.priority, class: ['btn', btn_class[object.priority], 'btn-sm'])
  end

  def viewed_by_assignee_icon
    ticket_view = TicketView.viewed_by(ticket, assignee)
    return unless ticket_view.exists?

    h.link_to h.content_tag(:i, '', class: 'ti-eye'), '#',
              { 'data-toggle' => 'popover',
                'data-content' => h.t(:ticket_viewed_by_assignee_content,
                                      time_elapsed: ticket_view.first.time_elapsed,
                                      scope: 'popover'),
                'title' => h.t(:ticket_viewed_by_assignee_title, scope: 'popover') }
  end

  def slack_created_message
    "<#{hostname}#{h.project_ticket_path(project, self)}|*[#{object.priority}] #{title}*>\n"\
    "```#{content.to_plain_text}```\n\n"\
    "_Ticket created by #{slack_created_by} and assigned to #{slack_assignee_name}_\n"
  end

  def slack_created_by
    alert_setting = AlertSetting.where(project: project, user: created_by, alertable: project.slack_authorization).first
    return unless alert_setting.present?

    alert_setting.slack_user_id ? "<@#{alert_setting.slack_user_id}>" : created_by.full_name
  end

  def slack_updated_message
    "_Ticket updated_\n"
  end

  def slack_assignee_name
    return 'no one' if assignee.nil?

    alert_setting = AlertSetting.where(project: project, user: assignee, alertable: project.slack_authorization).first
    return unless alert_setting.present?

    alert_setting.slack_user_id ? "<@#{alert_setting.slack_user_id}>" : assignee.full_name
  end

  # might be worth moving to a common class
  def hostname
    Rails.env.development? ? h.root_url(port: 3000).chomp!('/') : 'http://coderalert.com'
  end
end

class TicketDecorator < ApplicationDecorator
  delegate_all
  decorates_associations :assignee, :user, :comments

  def assignee_display
    return unless assignee

    assignee.full_name_link(project).concat(' ').concat(viewed_by_assignee_icon)
  end

  def priority_button
    btn_class = {
      'lowest' => 'btn-outline-dark',
      'low' => 'btn-info',
      'medium' => 'btn-secondary',
      'high' => 'btn-warning',
      'highest' => 'btn-danger'
    }

    h.content_tag(:button, priority_display, class: ['btn', btn_class[priority], 'btn-sm'])
  end

  def viewed_by_assignee_icon
    assignee_ticket_views = ticket_views.viewed_by(ticket, assignee)
    return unless assignee_ticket_views.exists?

    h.link_to h.content_tag(:i, '', class: 'ti-eye'), '#',
              { 'data-toggle' => 'popover',
                'data-content' => h.t(:ticket_viewed_by_assignee_content,
                                      time_elapsed: assignee_ticket_views.first.time_elapsed,
                                      scope: 'popover'),
                'title' => h.t(:ticket_viewed_by_assignee_title, scope: 'popover') }
  end

  def priority_display
    h.t(priority, scope: %i[ticket priorities])
  end

  def status_display
    h.t(status, scope: %i[ticket statuses])
  end

  def previous_status_button
    index = Ticket.statuses[status]

    return unless index.between?(1, 6)

    previous_status = Ticket.statuses.key(index - 1)
    h.link_to I18n.t(previous_status, scope: %i[ticket statuses]),
              h.project_ticket_status_path(project, object, status: previous_status),
              method: 'put',
              class: 'btn btn-light border'
  end

  def next_status_button
    index = Ticket.statuses[status]

    return if index >= 6

    next_status = Ticket.statuses.key(index + 1)
    h.link_to I18n.t(next_status, scope: %i[ticket statuses]),
              h.project_ticket_status_path(project, object, status: next_status),
              method: 'put',
              class: 'btn btn-light border'
  end

  def assignee_help_text
    return if project.schedules.present?

    h.t(:schedule_help_text, path: h.new_project_schedule_path(ticket.project), scope: :ticket).html_safe
  end

  # might be worth moving to a common class
  def hostname
    Rails.env.development? ? 'http://localhost:3000' : 'http://coderalert.com'
  end

  def updated_content
    formatted_changes = ''
    saved_changes.each do |attribute|
      next if attribute[0] == 'updated_at'

      if %w[status priority].include? attribute[0]
        attribute[1][0] = h.t(attribute[1][0].to_sym, scope: [:ticket, attribute[0].pluralize.to_sym])
        attribute[1][1] = h.t(attribute[1][1].to_sym, scope: [:ticket, attribute[0].pluralize.to_sym])
      elsif attribute[0] == 'assignee_id'
        attribute[0] = 'Assignee'
        attribute[1][0] = User.find(attribute[1][0].to_i).decorate.full_name if attribute[1][0]
        attribute[1][1] = User.find(attribute[1][1].to_i).decorate.full_name if attribute[1][1]
      end

      formatted_changes << "#{attribute[0].to_s.capitalize}: "\
                                    "Changed from #{attribute[1][0]}"\
                                    " to #{attribute[1][1]}\n"
    end
    formatted_changes
  end
end

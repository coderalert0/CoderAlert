class TicketDecorator < ApplicationDecorator
  delegate_all
  decorates_associations :assignee, :created_by, :comments

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
end

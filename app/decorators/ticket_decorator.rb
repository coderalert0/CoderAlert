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
    assignee_ticket_views = ticket_views.viewed_by(ticket, assignee)
    return unless assignee_ticket_views.exists?

    h.link_to h.content_tag(:i, '', class: 'ti-eye'), '#',
              { 'data-toggle' => 'popover',
                'data-content' => h.t(:ticket_viewed_by_assignee_content,
                                      time_elapsed: assignee_ticket_views.first.time_elapsed,
                                      scope: 'popover'),
                'title' => h.t(:ticket_viewed_by_assignee_title, scope: 'popover') }
  end

  def created_at_display
    created_at.strftime("%B %d, %Y %I:%M %p")
  end

  def updated_at_display
    updated_at.strftime("%B %d, %Y %I:%M %p")
  end
end

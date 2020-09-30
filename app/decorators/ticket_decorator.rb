class TicketDecorator < ApplicationDecorator
  delegate_all
  decorates_association :assignee

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
end

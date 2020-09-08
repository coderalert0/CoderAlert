class TicketDecorator < ApplicationDecorator
  delegate_all

  def priority
    btn_class = {
      'Lowest' => 'btn-outline-dark',
      'Low' => 'btn-info',
      'Medium' => 'btn-secondary',
      'High' => 'btn-warning',
      'Highest' => 'btn-danger'
    }

    h.content_tag(:button, object.priority, class: ['btn', btn_class[object.priority], 'btn-xs'])
  end
end

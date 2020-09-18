class UserDecorator < ApplicationDecorator
  delegate_all

  def full_name
    "#{first_name} #{last_name}"
  end

  def confirmation_state
    return unless confirmed_at.nil?

    h.link_to '(unconfirmed)', '#',
              { 'data-toggle' => 'popover',
                'data-content' => h.t(:account_unconfirmed_content, scope: 'popover'),
                'title' => h.t(:account_unconfirmed_title, scope: 'popover') }
  end

  def ticket_assignee_select_value(project)
    value = full_name
    value << ' (currently scheduled)' if self == project.on_call_user
    value
  end
end

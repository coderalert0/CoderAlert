class UserDecorator < ApplicationDecorator
  delegate_all

  def full_name
    "#{first_name} #{last_name}"
  end

  def full_name_link(project)
    h.link_to h.project_user_path(project, object) do
      h.concat profile_image_display('32x32>') if profile_image.attached?
      h.concat full_name
    end
  end

  def profile_image_display(size = '32x32', css_class = '')
    h.image_tag(profile_image.variant(resize: "#{size}>"), class: css_class) if profile_image.attached?
  end

  def confirmation_state
    return unless confirmed_at.nil?

    h.link_to h.t(:unconfirmed, scope: :permission_user), '#',
              { 'data-toggle' => 'popover',
                'data-content' => h.t(:account_unconfirmed_content, scope: 'popover'),
                'title' => h.t(:account_unconfirmed_title, scope: 'popover') }
  end

  def ticket_assignee_select_value(project)
    value = full_name
    value << ' (currently scheduled)' if self == project.on_call_user
    value
  end

  def color
    full_name.generate_random_color
  end
end

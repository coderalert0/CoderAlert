class SMSDecorator < ApplicationDecorator
  delegate_all

  def ticket_created_sms_message
    "[#{priority}] #{title}\n"\
    "#{content.to_plain_text}\n\n"\
    "Ticket created by #{user.decorate.full_name} and assigned to #{assignee_name}\n"\
    "#{hostname}#{h.project_ticket_path(project, self)}"
  end

  private

  def assignee_name
    return 'no one' if assignee.nil?

    assignee.decorate.full_name
  end

  # might be worth moving to a common class
  def hostname
    Rails.env.development? ? h.root_url(port: 3000).chomp!('/') : 'http://coderalert.com'
  end
end

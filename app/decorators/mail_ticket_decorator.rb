class MailTicketDecorator < TicketDecorator
  def created_subject
    "[#{h.t(priority, scope: %i[ticket priorities])}] #{title} was created by #{assignee.full_name}"
  end

  def updated_subject
    "[#{h.t(priority, scope: %i[ticket priorities])}] #{title} was updated"
  end

  def created_content
    "#{h.t(:title, scope: :ticket)}: #{title}\n\n"\
    "#{h.t(:priority, scope: :ticket)}: #{h.t(priority.to_sym, scope: %i[ticket priorities])}\n"\
    "#{h.t(:status, scope: :ticket)}: #{h.t(status.to_sym, scope: %i[ticket statuses])}\n\n"\
    "#{h.t(:description, scope: :ticket)}: #{content.to_plain_text}\n\n"\
  end
end

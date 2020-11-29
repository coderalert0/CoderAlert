class TicketMailerDecorator < TicketDecorator
  def created_subject
    "[#{h.t(priority, scope: %i[ticket priorities])}] #{h.t(:created_subject,
                                                            title: title,
                                                            assignee: assignee_name,
                                                            scope: %i[mailer ticket])}"
  end

  def updated_subject
    "[#{h.t(priority, scope: %i[ticket priorities])}] #{h.t(:updated_subject,
                                                            title: title,
                                                            scope: %i[mailer ticket])}"
  end

  def created_content
    "#{h.t(:title, scope: :ticket)}: #{title}<br/><br/>"\
    "#{h.t(:priority, scope: :ticket)}: #{h.t(priority.to_sym, scope: %i[ticket priorities])}<br/>"\
    "#{h.t(:status, scope: :ticket)}: #{h.t(status.to_sym, scope: %i[ticket statuses])}<br/>"\
    "#{h.t(:description, scope: :ticket)}: #{content.to_plain_text}<br/><br/>"\
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
                                    " to #{attribute[1][1]}<br/>"
    end
    formatted_changes
  end

  private

  def assignee_name
    assignee.nil? ? 'no one' : assignee.full_name
  end
end

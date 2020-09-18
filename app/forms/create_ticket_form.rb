class CreateTicketForm < BaseForm
  attr_accessor :title, :status, :priority, :description, :assignee_id, :created_by, :project
  attr_writer :ticket

  nested_attributes :title, :status, :priority, :description, :assignee_id,
                    :created_by, :project, to: :ticket

  accessible_attr :title, :status, :priority, :description, :assignee_id

  def ticket
    @ticket ||= Ticket.new
  end

  def _submit
    ticket.save!
  end
end

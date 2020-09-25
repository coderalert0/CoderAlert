class CreateTicketForm < BaseForm
  attr_accessor :title, :status, :priority, :description, :assignee_id, :created_by, :project, :attachments
  attr_writer :ticket

  nested_attributes :title, :status, :priority, :description, :assignee_id,
                    :created_by, :project, :attachments, to: :ticket

  accessible_attr :title, :status, :priority, :description, :assignee_id, attachments: []

  def ticket
    @ticket ||= Ticket.new
  end

  def _submit
    ticket.save!
  end

  private

  def initialize(args = {})
    super args_key_first args, :ticket
  end
end

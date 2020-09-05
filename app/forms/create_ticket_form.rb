class CreateTicketForm < BaseForm
  attr_accessor :title, :status, :priority, :description, :user, :project
  attr_writer :ticket

  nested_attributes :title, :status, :priority, :description, :user, :project, to: :ticket

  accessible_attr :title, :status, :priority, :description

  def ticket
    @ticket ||= Ticket.new
  end

  def _submit
    ticket.save!
  end
end

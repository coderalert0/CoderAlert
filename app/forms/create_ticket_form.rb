class CreateTicketForm < BaseForm
  attr_accessor :title, :status, :priority, :description
  attr_writer :ticket

  nested_attributes :title, :status, :priority, :description, to: :ticket

  accessible_attr :title, :status, :priority, :description

  validates_presence_of :title, :status, :priority, :description

  def ticket
    @ticket ||= Ticket.new
  end

  def _submit
    ticket.save!
  end
end

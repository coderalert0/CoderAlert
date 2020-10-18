class CreateTicketForm < BaseForm
  include Rails.application.routes.url_helpers

  attr_writer :ticket

  nested_attributes :title, :status, :priority, :content, :assignee_id, :attachments, to: :ticket

  accessible_attr :title, :status, :priority, :content, :assignee_id, attachments: []

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

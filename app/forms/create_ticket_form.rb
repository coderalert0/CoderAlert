class CreateTicketForm < BaseForm
  include Rails.application.routes.url_helpers

  attr_writer :ticket

  nested_attributes :title, :status, :priority, :content, :assignee_id, :attachments, to: :ticket

  accessible_attr :title, :status, :priority, :content, :assignee_id, attachments: []

  def ticket
    @ticket ||= Ticket.new
  end

  def assignee_help_text
    "You can create a <a target='_blank' href=#{new_project_schedule_path(ticket.project)}>Schedule</a> to automatically assign team members. i.e. rotate every sprint".html_safe unless ticket.project.schedules.present?
  end

  def _submit
    ticket.save!
  end

  private

  def initialize(args = {})
    super args_key_first args, :ticket
  end
end

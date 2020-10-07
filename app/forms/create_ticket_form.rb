class CreateTicketForm < BaseForm
  include Rails.application.routes.url_helpers

  attr_writer :ticket

  nested_attributes :title, :status, :priority, :content, :assignee_id, :attachments, to: :ticket

  accessible_attr :title, :status, :priority, :content, :assignee_id, attachments: []

  def ticket
    @ticket ||= Ticket.new
  end

  def assignee_help_text
    return if ticket.project.schedules.present?

    "You can create a <a target='_blank' href=#{new_project_schedule_path(ticket.project)}>Schedule</a>".html_safe\
      ' to automatically assign team members. i.e. rotate every sprint'
  end

  def _submit
    ticket.save!
  end

  private

  def initialize(args = {})
    super args_key_first args, :ticket
  end
end

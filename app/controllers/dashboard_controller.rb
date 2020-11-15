class DashboardController < ApplicationController
  def show
    authorize! :read, @current_project

    tickets = Ticket.for_project(@current_project)

    @unresolved_ticket_count = tickets.unresolved.count
    @in_progress_ticket_count = tickets.progress.count
    @on_call_user = @current_project.try(:schedules).try(:first).try(:on_call_user).try(:decorate).try(:full_name)
  end
end

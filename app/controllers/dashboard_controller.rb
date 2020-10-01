class DashboardController < ApplicationController
  def show
    tickets = Ticket.for_project(@current_project)

    @unresolved_ticket_count = tickets.unresolved.count
    @in_progress_ticket_count = tickets.in_progress.count
    @currently_on_call = @current_project.schedules.first.on_call_user.decorate
  end
end

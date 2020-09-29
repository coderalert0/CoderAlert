class DashboardController < ApplicationController
  def show
    project = Project.find(session[:project_id])
    tickets = Ticket.for_project(project)

    @unresolved_ticket_count = tickets.unresolved.count
    @in_progress_ticket_count = tickets.in_progress.count
    @currently_on_call = project.schedules.first.on_call_user.decorate
  end
end

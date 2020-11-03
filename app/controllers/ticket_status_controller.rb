class TicketStatusController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :ticket, through: :project, find_by: :slug

  def update
    @ticket.status = params[:status]

    if @ticket.save!
      flash.notice = t(:update, scope: %i[ticket_status flash])
      redirect_to project_tickets_path(@current_project)
    else
      flash.alert = @form.display_errors
      render :show
    end
  end
end

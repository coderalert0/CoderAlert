class TicketsController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :ticket

  def index
    @tickets = @project.tickets.decorate
  end

  def show
    @comment_form = CreateCommentForm.new
  end

  def new
    @form = CreateTicketForm.new
    @project = @project.decorate
  end

  def create
    @form = CreateTicketForm.new form_params.merge(created_by: current_user, project: @project)
    redirect_to project_tickets_path(@project) if @form.submit
  end

  def destroy
    redirect_to project_tickets_path(Project.last) if @ticket.destroy
  end

  private

  def form_params
    params.require(:create_ticket_form).permit(CreateTicketForm.accessible_attributes)
  end
end

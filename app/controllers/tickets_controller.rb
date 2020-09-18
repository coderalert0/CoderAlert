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
    if @form.submit
      flash.notice = 'The ticket was created successfully'
      redirect_to project_tickets_path(@project)
    else
      flash.alert = @form.display_errors
      render :new
    end
  end

  def destroy
    if @ticket.destroy
      flash.notice = 'The ticket was deleted successfully'
      redirect_to project_tickets_path(Project.last)
    else
      flash.alert = 'The ticket could not be deleted'
      render :show
    end
  end

  private

  def form_params
    params.require(:create_ticket_form).permit(CreateTicketForm.accessible_attributes)
  end
end

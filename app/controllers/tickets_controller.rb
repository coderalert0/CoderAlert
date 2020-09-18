class TicketsController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :ticket

  before_action :decorate_project, only: %i[index show new]

  def index
    @tickets = @project.tickets.decorate
  end

  def show
    @comment_form = CreateCommentForm.new
    populate_ticket_view
  end

  def new
    @form = CreateTicketForm.new
  end

  def create
    @form = CreateTicketForm.new form_params.merge(created_by: current_user, project: @project)

    if @form.submit
      @ticket = @form.ticket
      flash.notice = 'The ticket was created successfully'
      populate_ticket_view

      redirect_to project_tickets_path(@project)
    else
      flash.alert = @form.display_errors
      redirect_to action: :new
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

  def decorate_project
    @project = @project.decorate
  end

  def form_params
    params.require(:create_ticket_form).permit(CreateTicketForm.accessible_attributes)
  end

  def populate_ticket_view
    ticket_view = TicketView.find_or_create_by(ticket: @ticket, user: current_user)
    ticket_view.update(count: ticket_view.count + 1)
  end
end

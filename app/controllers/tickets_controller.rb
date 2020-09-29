class TicketsController < ApplicationController
  before_action :load_and_authorize_project
  before_action :load_and_authorize_ticket, only: %i[show edit update destroy]

  def index
    query = params[:search_tickets].try(:[], :query)

    @tickets = if query
                 Ticket.search("*#{query}*").records
               else
                 @project.tickets
               end
  end

  def show
    @comment_form = CreateCommentForm.new
    populate_ticket_view
  end

  def new
    @form = CreateTicketForm.new
  end

  def create
    @form = create_form

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

  def edit
    @form = EditTicketForm.new ticket: @ticket
  end

  def update
    @form = edit_form

    if @form.submit
      flash.notice = 'The ticket was edited successfully'
      redirect_to project_tickets_path(@project)
    else
      flash.alert = @form.display_errors
      render :edit
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

  def form_params(clazz)
    params.require(clazz.to_s.snakify.to_sym).permit(clazz.accessible_attributes)
  end

  def create_form
    CreateTicketForm.new form_params(CreateTicketForm).merge(created_by: current_user, project: @project)
  end

  def edit_form
    EditTicketForm.new form_params(EditTicketForm).merge(created_by: current_user, project: @project, ticket: @ticket)
  end

  def populate_ticket_view
    ticket_view = TicketView.find_or_create_by(ticket: @ticket, user: current_user)
    ticket_view.update(count: ticket_view.count + 1)
  end

  def load_and_authorize_project
    # need to authorize
    @project = Project.friendly.find(params[:project_id]).decorate
  end

  def load_and_authorize_ticket
    # need to authorize
    @ticket = Project.friendly.find(params[:project_id]).tickets.friendly.find(params[:id])
  end
end

class TicketsController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource through: :project, find_by: :slug

  def index
    query = params[:search_tickets].try(:[], :query)

    @tickets = if query
                 # scope this to the project or company
                 Ticket.search("*#{query}*").records
               else
                 @project.tickets
               end

    @tickets = @tickets.decorate
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

      redirect_to project_tickets_path(@current_project)
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
      redirect_to project_tickets_path(@current_project)
    else
      flash.alert = @form.display_errors
      render :edit
    end
  end

  def destroy
    if @ticket.destroy
      flash.notice = 'The ticket was deleted successfully'
      redirect_to project_tickets_path(@current_project)
    else
      flash.alert = 'The ticket could not be deleted'
      render :show
    end
  end

  private

  def create_form
    CreateTicketForm.new form_params(CreateTicketForm).merge(ticket: @ticket)
  end

  def edit_form
    EditTicketForm.new form_params(EditTicketForm).merge(ticket: @ticket)
  end

  def populate_ticket_view
    ticket_view = TicketView.find_or_create_by(ticket: @ticket, user: current_user)
    ticket_view.update(count: ticket_view.count + 1)
  end
end

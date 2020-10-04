class TicketsController < ApplicationController
  before_action :load_project
  before_action :load_ticket, only: %i[show edit update destroy]
  before_action :initialize_and_authorize_ticket, only: %i[new create]

  def index
    query = params[:search_tickets].try(:[], :query)

    @tickets = if query
                 # scope this to the project or company
                 Ticket.search("*#{query}*").records.decorate
               else
                 @project.tickets
               end
  end

  def show
    authorize! :read, @ticket

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

      redirect_to tickets_path
    else
      flash.alert = @form.display_errors
      redirect_to action: :new
    end
  end

  def edit
    authorize! :update, @ticket

    @form = EditTicketForm.new ticket: @ticket
  end

  def update
    authorize! :update, @ticket

    @form = edit_form

    if @form.submit
      flash.notice = 'The ticket was edited successfully'
      redirect_to tickets_path
    else
      flash.alert = @form.display_errors
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @ticket

    if @ticket.destroy
      flash.notice = 'The ticket was deleted successfully'
      redirect_to tickets_path
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

  def load_project
    @project = Project.friendly.find(session[:project_id]).decorate
  end

  def load_ticket
    @ticket = Project.friendly.find(session[:project_id]).tickets.friendly.find(params[:id])
  end

  def initialize_and_authorize_ticket
    @ticket = Ticket.new(created_by: current_user, project: @project)
    authorize! :create, @ticket
  end
end

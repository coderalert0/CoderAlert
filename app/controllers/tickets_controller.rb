class TicketsController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource through: :project, find_by: :slug

  def index
    query = params[:search_tickets].try(:[], :query)

    @tickets = if query
                 Ticket.search_project(query, @project).records
               else
                 @project.tickets.includes(:ticket_views)
               end

    @tickets = @tickets.page(params[:page]).decorate
  end

  def show
    @comment_form = CreateCommentForm.new
    populate_ticket_view
  end

  def new
    @form = CreateTicketForm.new(ticket: @ticket)
  end

  def create
    @form = create_form

    if @form.submit
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
      flash.notice = 'The ticket was edited successfully.'
      if @form.ticket.saved_change_to_status?(to: 'Closed')
        flash.notice << "<br/>Do you want to <a href=#{new_project_article_path}>create an Article</a>"\
                        ' describing how the issue was resolved? (it may help others in the future!)'
      end

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

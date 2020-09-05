class TicketsController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :ticket

  def show; end

  def new
    @form = CreateTicketForm.new
  end

  def create
    @form = CreateTicketForm.new form_params.merge(user: current_user, project: @project)
    redirect_to root_path if @form.submit
  end

  private

  def form_params
    params.require(:create_ticket_form).permit(CreateTicketForm.accessible_attributes)
  end
end

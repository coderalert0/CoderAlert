class TicketsController < ApplicationController
  load_and_authorize_resource :project

  def new
    @form = CreateTicketForm.new
  end
end

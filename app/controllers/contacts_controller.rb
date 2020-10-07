class ContactsController < ApplicationController
  load_and_authorize_resource

  def index
    # need to change this to generalize decorator type
    @authorizations = SlackAuthorizationDecorator.decorate_collection(Authorization.where(user: current_user))
  end

  def new
    @form = CreateContactForm.new

    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @form = CreateContactForm.new contact: @contact

    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @form = edit_form

    if @form.submit
      flash.notice = 'The contact information was edited successfully'
      redirect_to contacts_path
    else
      flash.alert = @form.display_errors
    end
  end

  def create
    @form = CreateContactForm.new form_params.merge(user: current_user)

    if @form.submit
      flash.notice = 'The contact information was created successfully'
      redirect_to contacts_path
    else
      flash.alert = @form.display_errors
    end
  end

  def destroy
    if @contact.destroy
      flash.notice = 'The contact was deleted successfully'
      redirect_to contacts_path
    else
      flash.alert = 'The contact could not be deleted'
      render :show
    end
  end

  private

  def form_params
    params.require(:create_contact_form).permit(CreateContactForm.accessible_attributes)
  end

  def edit_form
    EditContactForm.new form_params.merge(contact: @contact)
  end
end

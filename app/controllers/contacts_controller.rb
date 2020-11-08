class ContactsController < ApplicationController
  load_and_authorize_resource

  def index; end

  def new
    @form = CreateContactForm.new

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @form = create_form

    if @form.submit
      flash.notice = t(:create, scope: %i[contact flash])
      redirect_to contacts_path
    else
      flash.alert = @form.display_errors
    end
  end

  def edit
    @form = EditContactForm.new contact: @contact

    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @form = edit_form

    if @form.submit
      flash.notice = t(:update, scope: %i[contact flash])
      redirect_to contacts_path
    else
      flash.alert = @form.display_errors
    end
  end

  def destroy
    if @contact.destroy
      flash.notice = t(:destroy, scope: %i[contact flash])
      redirect_to contacts_path
    else
      flash.alert = t(:destroy_error, scope: %i[contact flash])
      render :show
    end
  end

  private

  def create_form
    CreateContactForm.new form_params(CreateContactForm).merge(user: current_user)
  end

  def edit_form
    EditContactForm.new form_params(EditContactForm).merge(contact: @contact)
  end
end

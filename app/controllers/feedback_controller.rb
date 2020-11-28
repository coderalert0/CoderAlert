class FeedbackController < ApplicationController
  def new
    @form = FeedbackForm.new

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @form = create_form

    if @form.submit
      flash.notice = t(:create, scope: %i[feedback flash])
      redirect_back(fallback_location: root_path)
    else
      flash.alert = @form.display_errors
    end
  end

  private

  def form_params
    params.require(:feedback_form).permit(FeedbackForm.accessible_attributes)
  end

  def create_form
    FeedbackForm.new form_params.merge(user: current_user)
  end
end

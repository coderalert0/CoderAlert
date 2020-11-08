class AlertSettingsController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource through: :project

  def index
    @alert_settings = @alert_settings.decorate
  end

  def edit
    @form = EditAlertSettingForm.new alert_setting: @alert_setting

    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @form = edit_form

    if @form.submit
      flash.notice = t(:update, scope: %i[alert_setting flash])
      redirect_to project_alert_settings_path
    else
      flash.alert = @form.display_errors
    end
  end

  private

  def form_params
    params.require(:edit_alert_setting_form).permit(EditAlertSettingForm.accessible_attributes)
  end

  def edit_form
    EditAlertSettingForm.new form_params.merge(alert_setting: @alert_setting)
  end
end

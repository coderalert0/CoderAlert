class EditAlertSettingForm < BaseForm
  nested_attributes :alert, to: :alert_setting

  accessible_attr :alert

  attr_accessor :alert_setting

  def _submit
    alert_setting.save!
  end

  private

  def initialize(args = {})
    super args_key_first args, :alert_setting
  end
end

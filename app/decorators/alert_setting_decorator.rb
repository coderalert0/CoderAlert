class AlertSettingDecorator < ApplicationDecorator
  delegate_all

  def alert_display
    alert? ? 'Yes' : 'No'
  end
end

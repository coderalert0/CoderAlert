class AlertSettingDecorator < ApplicationDecorator
  delegate_all
  decorates_association :alertable

  def alert_display
    h.t(alert.to_sym, scope: %i[notification_settings alerts])
  end
end

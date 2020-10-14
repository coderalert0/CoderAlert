class SlackAlertSettingListener
  def on_alert_setting_created(alert_setting)
    client = SlackClient.new(alert_setting: alert_setting)
    client.populate_slack_user_ids
  end
end

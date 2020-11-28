class SlackAlertSettingListener
  def on_alert_setting_created(alert_setting)
    return unless alert_setting.project.reload.slack_authorization

    client = SlackClient.new(alert_setting: alert_setting)
    client.populate_slack_user_ids
  end
end

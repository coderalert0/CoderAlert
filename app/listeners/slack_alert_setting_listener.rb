class SlackAlertSettingListener
  def on_alert_setting_created(alert_setting)
    populate_slack_user_ids(alert_setting)
  end

  private

  def populate_slack_user_ids(alert_setting)
    client = Slack::Web::Client.new(token: alert_setting.alertable.access_token)

    response = client.users_lookupByEmail(email: alert_setting.user.email)
    alert_setting.update_columns(slack_user_id: response.user.id, slack_email: response.user.profile.email)
  rescue StandardError => e
    Rails.logger.info e
    alert_setting.update_columns(slack_user_id: nil, slack_email: nil)
  end
end

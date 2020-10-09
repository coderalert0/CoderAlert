class SlackAuthorizationListener
  def on_slack_authorization_created(authorization)
    create_user_alert_settings(authorization)
    populate_slack_user_ids(authorization)
  end

  private

  def populate_slack_user_ids(authorization)
    client = Slack::Web::Client.new(token: authorization.access_token)

    authorization.alert_settings.each do |alert_setting|
      response = client.users_lookupByEmail(email: alert_setting.user.email)
      alert_setting.update(slack_user_id: response.user.id, slack_name: response.user.name)
    end
  rescue StandardError => e
    Rails.logger.info e
  end

  def create_user_alert_settings(authorization)
    authorization.project.users.each do |user|
      AlertSetting.find_or_create_by(alertable: authorization,
                                     user: user,
                                     project: authorization.project) do |alert_setting|
        alert_setting.alert = true unless alert_setting.alert
      end
    end
  end
end

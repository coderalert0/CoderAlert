class SlackAuthorizationListener
  def on_slack_authorization_created(authorization)
    populate_slack_user_ids(authorization)
    create_user_alert_settings(authorization)
  end

  private

  def populate_slack_user_ids(authorization)
    client = Slack::Web::Client.new(token: authorization.access_token)

    authorization.project.users.each do |user|
      response = client.users_lookupByEmail(email: user.email)
      user.update(slack_user_id: response.user.id)
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

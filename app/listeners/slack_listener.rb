class SlackListener
  def on_user_created(user)
    # update_slack_user_id
  end

  def on_slack_authorization_created(authorization)
    populate_slack_user_ids(authorization)
    create_user_alert_settings(authorization)
  end

  def on_ticket_created(ticket)
    client = Slack::Web::Client.new(token: ticket.project.slack_authorization.access_token)

    channel_id = create_channel(client, ticket)
    send_ticket_created_message(client, channel_id, user_list(ticket.project), ticket)
  end

  def on_ticket_updated(ticket)
    return if ticket.slack_channel_id.nil?
  end

  private

  def update_slack_user_id; end

  def user_list(project)
    project.users.with_slack_user_id.pluck(:slack_user_id).join(',')
  end

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

  def send_ticket_created_message(client, channel_id, user_list, ticket)
    client.conversations_invite(channel: channel_id, users: user_list)
    client.chat_postMessage(channel: channel_id, text: ticket.decorate.slack_created_message)
  rescue StandardError => e
    Rails.logger.info e
  end

  def create_channel(client, ticket)
    channel_name = "prod_support_#{ticket.slug}"
    response = client.conversations_create(name: channel_name, is_private: false)
    channel_id = response.channel.id
    ticket.update(slack_channel_id: channel_id)
    return channel_id
  rescue StandardError => e
    Rails.logger.info e
  end
end

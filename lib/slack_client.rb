class SlackClient
  def create_channel
    channel_name = "prod_support_#{@ticket.slug}"
    response = @client.conversations_create(name: channel_name, is_private: false)
    channel_id = response.channel.id
    @ticket.update_columns(slack_channel_id: channel_id)
    channel_id
  rescue StandardError => e
    Rails.logger.error e
  end

  def archive_channel
    return unless slack_channel?

    @client.conversations_archive(channel: @ticket.slack_channel_id)
  rescue StandardError => e
    Rails.logger.error e
  end

  def send_ticket_created_message
    @channel_id = create_channel

    @client.conversations_invite(channel: @channel_id, users: user_list)
    @client.chat_postMessage(channel: @channel_id, text: SlackDecorator.decorate(@ticket).ticket_created_message)
  rescue StandardError => e
    Rails.logger.error e
  end

  def send_ticket_updated_message
    return unless slack_channel?

    @client.chat_postMessage(channel: @ticket.slack_channel_id,
                             text: SlackDecorator.decorate(@ticket).ticket_updated_message)
  rescue StandardError => e
    Rails.logger.error e
  end

  def send_comment_added_message
    return unless slack_channel?

    @client.chat_postMessage(channel: @ticket.slack_channel_id,
                             text: SlackDecorator.decorate(@comment).comment_added)
  rescue StandardError => e
    Rails.logger.error e
  end

  def send_ticket_viewed_message
    return unless slack_channel?

    @client.chat_postMessage(channel: @ticket_view.ticket.slack_channel_id,
                             text: SlackDecorator.decorate(@ticket_view).ticket_viewed)
  rescue StandardError => e
    Rails.logger.error e
  end

  def populate_slack_user_ids
    response = @client.users_lookupByEmail(email: @alert_setting.user.email)
    @alert_setting.update_columns(slack_user_id: response.user.id, slack_email: response.user.profile.email)
  rescue StandardError => e
    Rails.logger.error e
    @alert_setting.update_columns(slack_user_id: nil, slack_email: nil)
  end

  private

  def initialize(args = {})
    key = args.keys.first
    variable_name = "@#{key}"
    instance_variable_set(variable_name, args[key])
    resource = instance_variable_get(variable_name)
    slack_authorization = resource.slack_authorization

    return if slack_authorization.nil?

    @ticket = resource.try(:ticket)
    @client = Slack::Web::Client.new(token: slack_authorization.access_token)
  rescue StandardError => e
    Rails.logger.error e
  end

  def user_list
    @ticket.project.slack_authorization
           .alert_settings
           .slack_alerts_on(@ticket)
           .pluck(:slack_user_id).join(',')
  end

  def slack_channel?
    @ticket.slack_channel_id.present?
  end
end

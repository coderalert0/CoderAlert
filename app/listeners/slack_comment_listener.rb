class SlackCommentListener
  def on_comment_created(comment)
    client = Slack::Web::Client.new(token: comment.commentable.project.slack_authorization.access_token)
    send_comment_added_message(client, comment)
  end

  private

  def send_comment_added_message(client, comment)
    return unless comment.commentable.is_a? Ticket

    client.chat_postMessage(channel: comment.commentable.slack_channel_id,
                            text: SlackDecorator.decorate(comment).comment_added)
  rescue StandardError => e
    Rails.logger.info e
  end
end

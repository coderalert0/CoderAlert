class SlackCommentListener
  def on_comment_created(comment)
    return unless comment.commentable.is_a? Ticket

    client = SlackClient.new(comment: comment)
    client.send_comment_added_message
  end
end

class CommentListener
  def on_comment_created(comment)
    return unless comment.commentable.is_a? Ticket
    CommentMailer.with(comment: comment).comment_created.deliver_later
  end

  def on_comment_updated(comment)
    return unless comment.commentable.is_a? Ticket
    CommentMailer.with(comment: comment).comment_updated.deliver_later
  end
end

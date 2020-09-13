class CommentListener
  def on_comment_created(comment)
    CommentMailer.with(comment: comment, changes: comment.changes.to_json).comment_created.deliver_later
  end

  def on_comment_updated(comment)
    CommentMailer.with(comment: comment, changes: comment.changes.to_json).comment_updated.deliver_later
  end
end

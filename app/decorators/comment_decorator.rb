class CommentDecorator < ApplicationDecorator
  delegate_all
  decorates_association :user

  def slack_comment_added
    "```#{content}```\n_Comment added by #{slack_user_name}:_"
  end

  def slack_user_name
    user.slack_user_id ? "<@#{user.slack_user_id}>" : user.full_name
  end
end

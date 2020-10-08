class CommentDecorator < ApplicationDecorator
  delegate_all
  decorates_association :user

  def slack_comment_added
    "Comment added by #{user.full_name}:\n #{content}\n"
  end
end

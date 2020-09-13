class CommentMailer < ApplicationMailer
  before_action :load_resources

  def comment_created
    mail(to: @comment.user.email, subject: "Comment was added by #{@comment.user.full_name}")
  end

  def comment_updated
    mail(to: @comment.user.email, subject: "Comment was edited by #{@comment.user.full_name}")
  end

  private

  def load_resources
    @comment = params[:comment].decorate
    @changes = params[:changes]
  end
end

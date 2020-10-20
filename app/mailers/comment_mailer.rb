class CommentMailer < ApplicationMailer
  before_action :load_resources

  def comment_created
    mail(to: receipient_email_addresses, subject: "Comment was added by #{@comment.user.full_name}")
  end

  def comment_updated
    mail(to: receipient_email_addresses, subject: "Comment was edited by #{@comment.user.full_name}")
  end

  private

  def load_resources
    @comment = params[:comment].decorate
    @changes = params[:changes]
  end

  # DRY it possibly, similar to ticket mailer method
  def receipient_email_addresses
    AlertSetting.email_alerts_on(@comment.commentable)
                .map { |ce| %("#{ce.alertable.user.decorate.full_name}" <#{ce.alertable.value}>) }
  end
end

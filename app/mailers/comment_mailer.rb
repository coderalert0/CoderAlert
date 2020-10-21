class CommentMailer < ApplicationMailer
  before_action :load_resources

  def comment_created
    mail(to: receipient_email_addresses, subject: @comment.created_subject)
  end

  def comment_updated
    mail(to: receipient_email_addresses, subject: @comment.updated_subject)
  end

  private

  def load_resources
    @comment = CommentMailerDecorator.decorate(params[:comment])
  end

  # DRY it possibly, similar to ticket mailer method
  def receipient_email_addresses
    AlertSetting.email_alerts_on(@comment.commentable)
                .map { |ce| %("#{ce.alertable.user.decorate.full_name}" <#{ce.alertable.value}>) }
  end
end

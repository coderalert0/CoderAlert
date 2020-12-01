class FeedbackMailer < ApplicationMailer
  before_action :load_resources

  def send_feedback
    mail(to: 'hello@coderalert.com', reply_to: @user.email, subject: t(:send_feedback))
  end

  private

  def load_resources
    @content = params[:content]
    @user = params[:user].decorate
  end
end

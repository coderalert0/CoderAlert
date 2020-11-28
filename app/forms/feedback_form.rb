class FeedbackForm < BaseForm
  attr_accessor :content, :user

  accessible_attr :content

  validates_presence_of :content

  def _submit
    FeedbackMailer.with(content: content, user: user).send_feedback.deliver_later
  end
end

class CommentMailerDecorator < ApplicationDecorator
  delegate_all
  decorates_association :user

  def created_subject
    h.t(:created_subject, title: commentable.slug, user: user.full_name, scope: %i[mailer comment]).to_s
  end

  def updated_subject
    h.t(:updated_subject, title: commentable.slug, user: user.full_name, scope: %i[mailer comment]).to_s
  end
end

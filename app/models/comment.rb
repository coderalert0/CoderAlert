class Comment < ApplicationRecord
  include DataEventPublishing

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates_presence_of :content, :user, :commentable

  publishes_lifecycle_events

  def ticket
    commentable if commentable.is_a? Ticket
  end

  def slack_authorization
    commentable.project.slack_authorization
  end
end

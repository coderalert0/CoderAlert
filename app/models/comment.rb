class Comment < ApplicationRecord
  include DataEventPublishing

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates_presence_of :content, :user, :commentable

  publishes_lifecycle_events
end

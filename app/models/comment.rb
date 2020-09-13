class Comment < ApplicationRecord
  include DataEventPublishing

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  publishes_lifecycle_events
end

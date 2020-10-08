class SlackAuthorization < Authorization
  include DataEventPublishing

  publishes_lifecycle_events
end

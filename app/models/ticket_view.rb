class TicketView < ApplicationRecord
  include DataEventPublishing

  belongs_to :ticket
  belongs_to :user

  validates_presence_of :ticket, :user

  scope :viewed_by, ->(ticket, user) { TicketView.where(ticket: ticket, user: user) }

  publishes_lifecycle_events

  def time_elapsed
    TimeDifference.between(DateTime.now, created_at).humanize
  end

  def slack_authorization
    ticket.project.slack_authorization
  end
end

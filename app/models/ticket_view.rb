class TicketView < ApplicationRecord
  belongs_to :ticket
  belongs_to :user

  validates_presence_of :ticket, :user

  scope :viewed_by, ->(ticket, user) { TicketView.where(ticket: ticket, user: user) }

  def time_elapsed
    TimeDifference.between(DateTime.now, created_at).humanize
  end
end

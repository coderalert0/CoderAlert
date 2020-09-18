class TicketView < ApplicationRecord
  belongs_to :ticket
  belongs_to :user

  validates_presence_of :ticket, :user

  scope :viewed_by, ->(ticket, user) { TicketView.where(ticket: ticket, user: user) }
end

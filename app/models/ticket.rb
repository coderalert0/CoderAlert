class Ticket < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validates_presence_of :title, :status, :priority, :description

  PRIORITY = %i[lowest low medium high highest].freeze
  STATUS = %i[draft open in_progress code_review qa reopened resolved closed cancelled].freeze
end

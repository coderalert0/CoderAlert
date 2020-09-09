class Ticket < ApplicationRecord
  belongs_to :project
  belongs_to :user
  has_many :comments, as: :commentable

  validates_presence_of :title, :status, :priority, :description

  PRIORITY = %i[lowest low medium high highest].freeze
  STATUS = %i[draft open in_progress code_review qa reopened resolved closed cancelled].freeze
end

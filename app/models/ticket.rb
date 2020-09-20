class Ticket < ApplicationRecord
  include DataEventPublishing

  belongs_to :project
  belongs_to :created_by, class_name: 'User', foreign_key: :created_by_id
  belongs_to :assignee, class_name: 'User', foreign_key: :assignee_id

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :ticket_views
  has_many_attached :attachments

  validates_presence_of :title, :status, :priority, :description, :created_by, :project
  validates :attachments,
            content_type: ['image/bmp', 'text/csv', 'application/msword', 'image/gif',
                           'image/jpeg', 'image/jpg', 'image/png', 'application/pdf',
                           'application/rtf', 'image/tiff', 'text/plain', 'application/vnd.ms-excel'],
            size: { less_than: 5.megabytes, message: 'file size limit is 5MB each' }

  PRIORITY = %i[lowest low medium high highest].freeze
  STATUS = %i[draft open in_progress code_review qa reopened resolved closed cancelled].freeze

  publishes_lifecycle_events
end

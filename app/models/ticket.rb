class Ticket < ApplicationRecord
  extend FriendlyId

  include DataEventPublishing
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :project
  belongs_to :created_by, class_name: 'User', foreign_key: :created_by_id
  belongs_to :assignee, class_name: 'User', foreign_key: :assignee_id

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :ticket_views
  has_many_attached :attachments

  scope :for_project, ->(project) { Ticket.where(project: project) }
  scope :unresolved, -> { Ticket.where.not(status: 'Resolved') }
  scope :in_progress, -> { Ticket.where(status: 'In Progress') }

  friendly_id :generate_ticket_id, use: :scoped, scope: :project

  settings do
    mappings dynamic: false do
      indexes :title, type: :text
      indexes :description, type: :text
      indexes :status, type: :text
      indexes :priority, type: :text
      indexes :slug, type: :keyword
      indexes :assignee, type: :object do
        indexes :first_name, type: :text
        indexes :last_name, type: :text
      end
    end
  end

  validates_presence_of :title, :status, :priority, :description, :created_by, :project
  validates :attachments,
            content_type: ['image/bmp', 'text/csv', 'application/msword', 'image/gif',
                           'image/jpeg', 'image/jpg', 'image/png', 'application/pdf',
                           'application/rtf', 'image/tiff', 'text/plain', 'application/vnd.ms-excel'],
            size: { less_than: 5.megabytes, message: 'file size limit is 5MB each' }

  PRIORITY = %i[lowest low medium high highest].freeze
  STATUS = %i[draft open in_progress code_review qa reopened resolved closed cancelled].freeze

  publishes_lifecycle_events

  def as_indexed_json(options = {})
    as_json(
      options.merge(
        only: %i[title description status priority slug],
        include: { assignee: { only: %i[first_name last_name] } }
      )
    )
  end

  def generate_ticket_id
    # will cause issues if we allow deleting tickets
    "#{project.key}-#{Ticket.for_project(project).count + 1}"
  end
end

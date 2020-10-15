class Ticket < ApplicationRecord
  extend FriendlyId

  include DataEventPublishing
  include Searchable
  include AttachmentValidateable

  belongs_to :project
  belongs_to :created_by, class_name: 'User', foreign_key: :created_by_id
  belongs_to :assignee, class_name: 'User', foreign_key: :assignee_id

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :ticket_views
  has_many_attached :attachments

  friendly_id :generate_ticket_id, use: :scoped, scope: :project

  after_update :publish_ticket_closed, if: :closed?
  after_update :publish_ticket_cancelled, if: :cancelled?

  settings do
    mappings dynamic: false do
      indexes :title, type: :text
      indexes :content, type: :text
      indexes :status, type: :text
      indexes :priority, type: :text
      indexes :slug, type: :keyword
      indexes :project_id, type: :keyword
      indexes :assignee, type: :object do
        indexes :first_name, type: :text
        indexes :last_name, type: :text
      end
    end
  end

  enum priority: { lowest: 0, low: 1, medium: 2, high: 3, highest: 4 }
  enum status: { draft: 0, open: 1, in_progress: 2, code_review: 3, qa: 4, reopened: 5, resolved: 6, closed: 7, cancelled: 8 }

  validates_presence_of :title, :status, :priority, :content, :created_by, :project

  has_rich_text :content

  scope :for_project, ->(project) { Ticket.where(project: project) }
  scope :unresolved, -> { Ticket.where.not(status: :resolved) }
  scope :in_progress, -> { Ticket.where(status: :in_progress) }

  publishes_lifecycle_events

  def as_indexed_json(options = {})
    as_json(
      options.merge(
        only: %i[title content status priority slug project_id],
        include: { assignee: { only: %i[first_name last_name] } }
      )
    )
  end

  def generate_ticket_id
    # will cause issues if we allow deleting tickets
    "#{project.key}-#{Ticket.for_project(project).count + 1}"
  end

  def cancelled?
    status == I18n.t(:cancelled, scope: %i[ticket statuses])
  end

  def closed?
    status == I18n.t(:closed, scope: %i[ticket statuses])
  end

  def publish_ticket_cancelled
    _publish self, :cancelled
  end

  def publish_ticket_closed
    _publish self, :closed
  end

  # workaround to facilitate DRY'ing slack_client
  def ticket
    self
  end

  def slack_authorization
    project.slack_authorization
  end
end

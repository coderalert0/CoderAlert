class User < ApplicationRecord
  include DataEventPublishing

  belongs_to :company
  belongs_to :last_accessed_project, class_name: 'Project', optional: true

  has_many :project_users, dependent: :destroy
  has_many :projects, through: :project_users
  has_many :schedule_users, dependent: :destroy
  has_many :assigned_tickets, class_name: 'Ticket', foreign_key: :assignee_id, dependent: :nullify
  has_many :created_tickets, class_name: 'Ticket', foreign_key: :user_id, dependent: :nullify
  has_many :contacts, dependent: :destroy
  has_many :alert_settings

  has_one :contact_email, dependent: :destroy
  has_one_attached :profile_image

  accepts_nested_attributes_for :company

  devise :invitable, :database_authenticatable, :registerable, :trackable, :timeoutable,
         :recoverable, :rememberable, :validatable, :confirmable, :lockable,
         :validatable

  validates_presence_of :email, :first_name, :last_name

  validates :profile_image,
            attached: true,
            content_type: ['image/bmp', 'image/gif', 'image/jpeg', 'image/jpg', 'image/png', 'image/tiff'],
            size: { less_than: 5.megabytes, message: 'file size limit is 5MB each' }

  scope :confirmed, -> { where.not(confirmed_at: nil) }

  scope :unpermissioned_to_project, lambda { |project|
    joins(:company).where(companies: { id: project.company_id })
                   .joins("LEFT JOIN project_users pu ON users.id = pu.user_id AND pu.project_id = #{project.id}")
                   .where(pu: { project_id: nil })
  }

  publishes_lifecycle_events
end

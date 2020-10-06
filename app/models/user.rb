class User < ApplicationRecord
  belongs_to :company
  belongs_to :last_accessed_project, class_name: 'Project', optional: true

  has_many :project_users, dependent: :destroy
  has_many :projects, through: :project_users
  has_many :schedule_users, dependent: :destroy
  has_many :contacts, dependent: :destroy
  has_many :tickets, foreign_key: :created_by_id, dependent: :nullify
  has_one_attached :profile_image

  accepts_nested_attributes_for :company

  devise :invitable, :database_authenticatable, :registerable, :trackable, :timeoutable,
         :recoverable, :rememberable, :validatable, :confirmable, :lockable,
         :validatable

  validates_presence_of :email, :first_name, :last_name

  scope :confirmed, -> { User.where.not(confirmed_at: nil) }

  scope :unpermissioned_to_project, lambda { |project|
    joins(:company).where(companies: { id: project.company_id })
                   .joins("LEFT JOIN project_users pu ON users.id = pu.user_id AND pu.project_id = #{project.id}")
                   .where(pu: { project_id: nil })
  }
end

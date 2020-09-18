class User < ApplicationRecord
  belongs_to :company
  has_many :project_users, dependent: :destroy
  has_many :projects, through: :project_users
  has_many :schedule_users, dependent: :destroy

  accepts_nested_attributes_for :company

  devise :invitable, :database_authenticatable, :registerable, :trackable, :timeoutable,
         :recoverable, :rememberable, :validatable, :confirmable, :lockable,
         :validatable

  validates_presence_of :email, :first_name, :last_name

  scope :unpermissioned_to_project, lambda { |project|
    joins(:company).where(companies: { id: project.company_id })
                   .joins("LEFT JOIN project_users pu ON users.id = pu.user_id AND pu.project_id = #{project.id}")
                   .where(pu: { project_id: nil })
  }
end

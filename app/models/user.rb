class User < ApplicationRecord
  belongs_to :company
  has_many :project_users
  has_many :projects, through: :project_users

  accepts_nested_attributes_for :company

  devise :database_authenticatable, :registerable, :trackable, :timeoutable,
         :recoverable, :rememberable, :validatable, :confirmable, :lockable,
         :validatable

  scope :unpermissioned_to_project, lambda { |project|
    joins(:company)
      .joins("LEFT JOIN project_users pu ON users.id = pu.user_id AND pu.project_id = #{project.id}")
      .where(pu: { project_id: nil })
  }
end

class User < ApplicationRecord
  belongs_to :company
  has_many :project_users
  has_many :projects, through: :project_users

  accepts_nested_attributes_for :company

  devise :database_authenticatable, :registerable, :trackable, :timeoutable,
         :recoverable, :rememberable, :validatable, :confirmable, :lockable,
         :validatable
end

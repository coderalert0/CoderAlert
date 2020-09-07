class Project < ApplicationRecord
  belongs_to :company
  has_many :tickets
  has_many :project_users
  has_many :users, through: :project_users

  validates_presence_of :name, :company
  validates_uniqueness_of :name, scope: :company
end

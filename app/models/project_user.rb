class ProjectUser < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validates_presence_of :project, :user
end

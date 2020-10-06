class Authorization < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validates_presence_of :access_token, :project, :user
end

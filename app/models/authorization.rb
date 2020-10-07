class Authorization < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validates_presence_of :type, :access_token, :project, :user
end

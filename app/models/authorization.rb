class Authorization < ApplicationRecord
  belongs_to :project
  belongs_to :user

  has_many :alert_settings, as: :alertable, dependent: :destroy

  validates_presence_of :type, :access_token, :project, :user
end

class Authorization < ApplicationRecord
  include DataEventPublishing

  belongs_to :project
  belongs_to :user

  has_many :alert_settings, as: :alertable, dependent: :destroy

  validates_presence_of :type, :access_token, :project, :user

  attr_encrypted :access_token, key: Rails.application.credentials.key

  publishes_lifecycle_events
end

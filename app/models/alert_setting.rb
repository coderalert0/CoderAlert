class AlertSetting < ApplicationRecord
  include DataEventPublishing

  belongs_to :alertable, polymorphic: true
  belongs_to :user
  belongs_to :project

  validates_presence_of :alertable, :user, :project

  scope :for_project_user, ->(project, user) { AlertSetting.where(project: project, user: user) }
  scope :with_slack_alerts_on, -> { AlertSetting.where.not(slack_user_id: nil).where(alert: true) }

  publishes_lifecycle_events
end

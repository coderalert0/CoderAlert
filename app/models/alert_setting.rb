class AlertSetting < ApplicationRecord
  belongs_to :alertable, polymorphic: true
  belongs_to :user
  belongs_to :project

  validates_presence_of :alertable, :user, :project

  scope :for_project_user, ->(project, user) { AlertSetting.where(project: project, user: user) }
  scope :with_slack_user_id, -> { AlertSetting.where.not(slack_user_id: nil) }
end

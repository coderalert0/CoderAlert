class AlertSetting < ApplicationRecord
  include DataEventPublishing

  belongs_to :alertable, polymorphic: true
  belongs_to :user
  belongs_to :project

  validates_presence_of :alertable, :user, :project

  scope :for_project_user, ->(project, user) { AlertSetting.where(project: project, user: user) }
  scope :slack_alerts_on, -> { AlertSetting.where.not(slack_user_id: nil).where(alert: true) }
  scope :sms_alerts_on, lambda { |project|
                          AlertSetting.where(project: project,
                                             alertable_type: 'Contact',
                                             alert: true)
                        }

  publishes_lifecycle_events
end

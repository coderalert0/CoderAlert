class AlertSetting < ApplicationRecord
  include DataEventPublishing

  belongs_to :alertable, polymorphic: true
  belongs_to :user
  belongs_to :project

  validates_presence_of :alertable, :user, :project, :alert

  scope :for_project_user, ->(project, user) { AlertSetting.where(project: project, user: user) }

  scope :all_or_assigned, lambda { |user|
    AlertSetting
      .where('alert = ? OR (alert = ? AND user_id = ?)',
             ALL, ASSIGNED, user.try(:id))
  }

  scope :slack_alerts_on, lambda { |ticket|
    AlertSetting
      .where(project: ticket.project)
      .where.not(slack_user_id: nil)
      .all_or_assigned(ticket.assignee)
  }

  scope :sms_alerts_on, lambda { |ticket|
    AlertSetting
      .where(project: ticket.project, alertable_type: 'Phone')
      .all_or_assigned(ticket.assignee)
  }

  scope :email_alerts_on, lambda { |ticket|
    AlertSetting
      .where(project: ticket.project, alertable_type: 'ContactEmail')
      .all_or_assigned(ticket.assignee)
  }

  publishes_lifecycle_events

  ALERTS = [ALL = :all, ASSIGNED = :assigned, NONE = :none].freeze

  def slack_authorization
    alertable if alertable.is_a? SlackAuthorization
  end
end

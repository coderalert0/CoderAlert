class PermissionUserForm < BaseForm
  attr_accessor :user_id, :project

  accessible_attr :user_id

  def _submit
    ActiveRecord::Base.transaction do
      project_user = project.project_users.build(user: user)
      project_user.save!
      create_slack_alert_settings if project.slack_authorization.present?
      create_contact_alert_settings
    end
  end

  private

  def initialize(args = {})
    self.user = User.find(args[:user]) if args[:user]
    super
  end

  def create_slack_alert_settings
    AlertSetting.create(alertable: project.slack_authorization, user: user, project: project, alert: true)
  end

  def create_contact_alert_settings
    user.contacts.each do |contact|
      AlertSetting.create(alertable: contact, user: user, project: project, alert: false)
    end
  end

  def user
    User.find(user_id)
  end
end

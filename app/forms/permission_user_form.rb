class PermissionUserForm < BaseForm
  attr_writer :project_user

  nested_attributes :user_id, :project, :admin, to: :project_user

  accessible_attr :user_id, :admin

  def user
    User.find(user_id)
  end

  def project_user
    @project_user ||= ProjectUser.new
  end

  def _submit
    ActiveRecord::Base.transaction do
      project_user.save!
      create_slack_alert_settings if project.slack_authorization.present?
      create_contact_alert_settings
    end
  end

  private

  def initialize(args = {})
    self.user = User.find(args[:user]) if args[:user]
    super args_key_first args, :project_user
  end

  # method repeated, try to DRY it
  def create_slack_alert_settings
    AlertSetting.create(alertable: project.slack_authorization, user: user, project: project, alert: true)
  end

  def create_contact_alert_settings
    user.contacts.each do |contact|
      AlertSetting.create(alertable: contact, user: user, project: project, alert: false)
    end
  end
end

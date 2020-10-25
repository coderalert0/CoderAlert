class InviteUserForm < BaseForm
  attr_accessor :first_name, :last_name, :email, :project_ids, :company, :success

  accessible_attr :first_name, :last_name, :email, project_ids: []

  validates_presence_of :first_name, :last_name, :email, :project_ids

  def _submit
    ActiveRecord::Base.transaction do
      user = User.invite!(first_name: first_name,
                          last_name: last_name,
                          email: email,
                          company: company)

      projects.each do |project|
        ProjectUser.find_or_create_by(user: user, project: project)
        ContactEmail.find_or_create_by(user: user, value: user.email)

        create_slack_alert_settings(project, user) if project.slack_authorization.present?
        create_email_alert_settings(project, user)
      end
    end
    self.success = true
  end

  alias save submit

  def projects
    Project.find(project_ids)
  end

  private

  # method repeated, try to DRY it
  def create_slack_alert_settings(project, user)
    AlertSetting.find_or_create_by(alertable: project.slack_authorization,
                                   user: user,
                                   project: project) do |alert_setting|
      alert_setting.alert = AlertSetting::ALL
    end
  end

  def create_email_alert_settings(project, user)
    AlertSetting.find_or_create_by(alertable: user.contact_email,
                                   user: user,
                                   project: project) do |alert_setting|
      alert_setting.alert = AlertSetting::ALL
    end
  end
end

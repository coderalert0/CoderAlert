class InviteUserForm < BaseForm
  attr_accessor :first_name, :last_name, :email, :project_ids, :company, :success

  accessible_attr :first_name, :last_name, :email, project_ids: []

  validates_presence_of :first_name, :last_name, :email, :project_ids

  def _submit
    ActiveRecord::Base.transaction do
      user = User.invite!(first_name: first_name, last_name: last_name, email: email, company: company)
      projects = Project.find(project_ids)

      projects.each do |project|
        ProjectUser.find_or_create_by(user: user, project: project)
        create_slack_alert_settings(project, user) if project.slack_authorization.present?
      end
    end
    self.success = true
  end

  alias save submit

  private

  # method repeated, try to DRY it
  def create_slack_alert_settings(project, user)
    AlertSetting.create(alertable: project.slack_authorization, user: user, project: project, alert: AlertSetting::ALL)
  end
end

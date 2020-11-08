class CreateProjectForm < BaseForm
  attr_accessor :success
  attr_writer :project

  nested_attributes :name, :company, :key, :user, to: :project

  accessible_attr :name, :key

  def key=(value)
    project.key = value.present? ? value.upcase : project.name.split.map(&:first).join.upcase
  end

  def project
    @project ||= Project.new
  end

  def _submit
    ActiveRecord::Base.transaction do
      project.save!
      user = project.user

      ProjectUser.find_or_create_by(user: user, project: project, admin: true)

      user.contacts.each do |contact|
        AlertSetting.find_or_create_by(alertable: contact, user: user, project: project) do |alert_setting|
          alert_setting.alert = AlertSetting::ALL
        end
      end
    end
    self.success = true
  end
  alias save submit

  private

  def initialize(args = {})
    super args_key_first args, :project
  end
end

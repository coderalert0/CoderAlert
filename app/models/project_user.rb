class ProjectUser < ApplicationRecord
  belongs_to :project
  belongs_to :user

  has_many :alert_settings, through: :project

  scope :admin, -> { ProjectUser.where(admin: true) }

  validates_presence_of :project, :user

  before_destroy :validate_atleast_one_admin, on: :destroy
  after_destroy :destroy_alert_settings, :nullify_last_accessed_project

  private

  # workaround for activerecord error for dependent destroy
  def destroy_alert_settings
    alert_settings.each(&:destroy)
  end

  def nullify_last_accessed_project
    user.update(last_accessed_project: nil) if user.last_accessed_project == project
  end

  def validate_atleast_one_admin
    throw(:abort) if project.project_users.admin.size == 1 && admin?
  end
end

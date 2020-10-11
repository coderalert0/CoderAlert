class ProjectUser < ApplicationRecord
  belongs_to :project
  belongs_to :user

  has_many :alert_settings, through: :project

  after_destroy :destroy_alert_settings

  validates_presence_of :project, :user

  private

  # workaround for activerecord error for dependent destroy
  def destroy_alert_settings
    alert_settings.each(&:destroy)
  end
end

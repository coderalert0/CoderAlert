class ProjectUserDecorator < ApplicationDecorator
  decorates_associations :user, :project
  delegate_all

  def admin_display
    admin? ? 'Yes' : 'No'
  end
end

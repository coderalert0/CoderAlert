class ProjectUserDecorator < ApplicationDecorator
  decorates_associations :user, :project
end

class ProjectDecorator < ApplicationDecorator
  delegate_all
  decorates_associations :users, :tickets
end

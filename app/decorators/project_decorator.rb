class ProjectDecorator < ApplicationDecorator
  delegate_all
  decorates_association :users
end

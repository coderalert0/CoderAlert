class ArticleDecorator < ApplicationDecorator
  delegate_all
  decorates_associations :user, :comments
end

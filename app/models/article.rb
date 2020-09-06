class Article < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validates_presence_of :title, :description
end

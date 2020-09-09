class Article < ApplicationRecord
  belongs_to :project
  belongs_to :user
  has_many :comments, as: :commentable

  validates_presence_of :title, :content
end

class Article < ApplicationRecord
  extend FriendlyId

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :project
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many_attached :attachments

  friendly_id :title, use: :scoped, scope: :project

  settings do
    mappings dynamic: false do
      indexes :title, type: :text
      indexes :content, type: :text
      indexes :user, type: :object do
        indexes :first_name, type: :text
        indexes :last_name, type: :text
      end
    end
  end

  validates_presence_of :title, :content, :project, :user
  validates :attachments,
            content_type: ['image/bmp', 'text/csv', 'application/msword', 'image/gif',
                           'image/jpeg', 'image/jpg', 'image/png', 'application/pdf',
                           'application/rtf', 'image/tiff', 'text/plain', 'application/vnd.ms-excel'],
            size: { less_than: 5.megabytes, message: 'file size limit is 5MB each' }

  def as_indexed_json(options = {})
    as_json(
      options.merge(
        only: %i[title content],
        include: { user: { only: %i[first_name last_name] } }
      )
    )
  end
end

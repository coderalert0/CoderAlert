class Article < ApplicationRecord
  extend FriendlyId

  include Searchable

  belongs_to :project
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many_attached :attachments

  friendly_id :title, use: :scoped, scope: :project

  settings do
    mappings dynamic: false do
      indexes :title, type: :text
      indexes :content, type: :text
      indexes :project_id, type: :keyword
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

  has_rich_text :content

  def as_indexed_json(options = {})
    as_json(
      options.merge(
        only: %i[title content project_id],
        include: { user: { only: %i[first_name last_name] } }
      )
    )
  end
end

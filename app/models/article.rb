class Article < ApplicationRecord
  belongs_to :project
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many_attached :attachments

  validates_presence_of :title, :content, :project, :user
  validates :attachments,
            content_type: ['image/bmp', 'text/csv', 'application/msword', 'image/gif',
                           'image/jpeg', 'image/jpg', 'image/png', 'application/pdf',
                           'application/rtf', 'image/tiff', 'text/plain', 'application/vnd.ms-excel'],
            size: { less_than: 5.megabytes, message: 'file size limit is 5MB each' }
end

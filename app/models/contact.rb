class Contact < ApplicationRecord
  belongs_to :user

  has_many :alert_settings, as: :alertable, dependent: :destroy

  validates_presence_of :type, :value, :user
end

require_dependency Phone.to_s

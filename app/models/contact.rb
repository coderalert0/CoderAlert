class Contact < ApplicationRecord
  belongs_to :user

  validates_presence_of :type, :value, :user
end

require_dependency Phone.to_s

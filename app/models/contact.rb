class Contact < ApplicationRecord
  belongs_to :user

  has_many :alert_settings, as: :alertable, dependent: :destroy

  validates_presence_of :type, :value, :user
  validates :value, email: true, if: proc { |c| c.type == 'ContactEmail' }
end

require_dependency 'contact_email'
require_dependency 'phone'

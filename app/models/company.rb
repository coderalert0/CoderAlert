class Company < ApplicationRecord
  has_many :projects, dependent: :destroy
  has_many :users, dependent: :destroy

  validates_presence_of :name
end

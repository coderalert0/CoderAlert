class Project < ApplicationRecord
  belongs_to :company
  has_many :tickets

  validates_presence_of :name, :company
  validates_uniqueness_of :name, scope: :company
end

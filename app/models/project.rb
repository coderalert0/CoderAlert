class Project < ApplicationRecord
  belongs_to :company
  has_many :tickets
  has_many :articles
  has_many :schedules
  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users

  validates_presence_of :name, :company
  validates_uniqueness_of :name, scope: :company

  def on_call_user
    schedules.first.on_call_user
  end
end

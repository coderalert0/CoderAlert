class Project < ApplicationRecord
  extend FriendlyId

  belongs_to :company
  belongs_to :user

  has_many :tickets, -> { order created_at: :desc }, dependent: :destroy
  has_many :articles, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users

  # this is a workaround to facilitate scoping tickets to a project
  friendly_id :id, use: :slugged

  after_create :populate_friendly_id

  validates_presence_of :name, :company
  validates_uniqueness_of :name, :key, scope: :company

  def on_call_user
    schedules.first.on_call_user
  end

  private

  def populate_friendly_id
    self.slug = id
    save
  end
end

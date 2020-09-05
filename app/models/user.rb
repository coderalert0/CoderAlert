class User < ApplicationRecord
  belongs_to :company
  has_many :projects, through: :company

  accepts_nested_attributes_for :company

  devise :database_authenticatable, :registerable, :trackable, :timeoutable,
         :recoverable, :rememberable, :validatable, :confirmable, :lockable,
         :validatable
end

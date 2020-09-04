class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :trackable, :timeoutable,
         :recoverable, :rememberable, :validatable, :confirmable, :lockable,
         :validatable

  def admin?
    has_role?(:admin)
  end
end

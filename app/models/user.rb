class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :trackable, :timeoutable,
         :recoverable, :rememberable, :validatable, :confirmable, :lockable,
         :validatable
end

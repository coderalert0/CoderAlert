class UserDecorator < ApplicationDecorator
  delegate_all

  def full_name
    "#{first_name} #{last_name}"
  end

  def confirmation_state
    '(unconfirmed)' if confirmed_at.nil?
  end
end

class ContactEmailDecorator < ApplicationDecorator
  delegate_all

  def type_display
    'Email'
  end
end

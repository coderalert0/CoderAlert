class PhoneDecorator < ApplicationDecorator
  delegate_all

  def type_display
    'Phone'
  end
end

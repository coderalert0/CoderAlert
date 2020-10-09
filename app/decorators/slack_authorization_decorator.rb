class SlackAuthorizationDecorator < ApplicationDecorator
  delegate_all

  def name_display
    'Slack'
  end
end

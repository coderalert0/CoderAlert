class SlackAuthorizationDecorator < ApplicationDecorator
  delegate_all

  def display_name
    'Slack'
  end
end

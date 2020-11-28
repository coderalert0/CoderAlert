module SlackConcern
  extend ActiveSupport::Concern

  HOSTNAMES = {
    'development' => 'http%3A%2F%2Flocalhost%3A3000',
    'staging' => 'https%3A%2F%2Fstaging.coderalert.com',
    'production' => 'https%3A%2F%2Fapp.coderalert.com'
  }.freeze

  def slack_redirect_url
    "https://slack.com/oauth/v2/authorize?scope=incoming-webhook,commands,users:read,channels:join,channels:manage&client_id=1423806287889.1435611370784&redirect_uri=#{HOSTNAMES[Rails.env]}%2Fslack_auth%2Fcallback%3Fproject_id%3D#{@project.id}"
  end
end

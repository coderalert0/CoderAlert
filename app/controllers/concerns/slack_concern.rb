module SlackConcern
  extend ActiveSupport::Concern

  def slack_redirect_url
    hostname = case Rails.env
               when 'development'
                 'http%3A%2F%2Flocalhost%3A3000'
               when 'production'
                 'https%3A%2F%2Fapp.coderalert.com'
               when 'staging'
                 'https%3A%2F%2Fstaging.coderalert.com'
               end

    "https://slack.com/oauth/v2/authorize?scope=incoming-webhook,commands,users:read,channels:join,channels:manage&client_id=1423806287889.1435611370784&redirect_uri=#{hostname}%2Fslack_auth%2Fcallback%3Fproject_id%3D#{@project.id}"
  end
end

class SlackAuthorizationController < ApplicationController
  def callback
    @project = Project.find(params[:project_id])

    begin
      ActiveRecord::Base.transaction do
        response = Slack::Web::Client.new.oauth_v2_access(oauth_params)

        Rails.logger.info response.inspect

        @authorization = SlackAuthorization.find_or_create_by(auth_id: response.team.id)

        if @authorization.update(authorization_params(response))
          flash.notice = 'Slack successfully connected'
        else
          flash.alert = 'Slack authorization could not be saved'
        end

        @project.users.each do |user|
          AlertSetting.find_or_create_by(alertable: @authorization, user: user, project: @project) do |alert_setting|
            alert_setting.alert = true if alert_setting.alert.nil?
          end
        end
      end
    rescue StandardError
      flash.alert = 'Slack could not be connected'
    end

    redirect_to project_alert_settings_path(@project)
  end

  private

  def authorization_params(response)
    { auth_id: response.team.id,
      access_token: response.access_token,
      name: response.team.name,
      channel: response.incoming_webhook[:channel],
      webhook_url: response.incoming_webhook[:url],
      user: current_user,
      project: @project }
  end

  def oauth_params
    { client_id: Rails.application.credentials.dig(:slack, :client_id),
      client_secret: Rails.application.credentials.dig(:slack, :client_secret),
      code: params[:code],
      redirect_uri: slack_auth_callback_url(project_id: @project.id) }
  end
end

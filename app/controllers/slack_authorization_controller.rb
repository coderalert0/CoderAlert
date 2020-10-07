class SlackAuthorizationController < ApplicationController
  def callback
    @project = Project.find(params[:project_id])

    begin
      ActiveRecord::Base.transaction do
        @response = retrieve_access_token
        Rails.logger.info @response.inspect

        create_authorization
        create_project_user_alert_settings
      end
    rescue StandardError
      flash.alert = 'Slack could not be connected'
      redirect_to_failure_path and return
    end

    redirect_to_success_path and return
  end

  private

  def redirect_to_success_path
    redirect_to welcome? ? root_path : project_alert_settings_path(@project)
  end

  def redirect_to_failure_path
    redirect_to welcome? ? after_signup_path(:slack) : project_alert_settings_path(@project)
  end

  def authorization_params
    { auth_id: @response.team.id,
      access_token: @response.access_token,
      name: @response.team.name,
      channel: @response.incoming_webhook[:channel],
      webhook_url: @response.incoming_webhook[:url],
      user: current_user,
      project: @project }
  end

  def oauth_params
    { client_id: Rails.application.credentials.dig(:slack, :client_id),
      client_secret: Rails.application.credentials.dig(:slack, :client_secret),
      code: params[:code],
      redirect_uri: slack_auth_callback_url(project_id: @project.id, welcome: welcome) }
  end

  def welcome?
    welcome == '1'
  end

  def welcome
    params[:welcome]
  end

  def create_project_user_alert_settings
    @project.users.each do |user|
      AlertSetting.find_or_create_by(alertable: @authorization, user: user, project: @project) do |alert_setting|
        alert_setting.alert = true unless alert_setting.alert
      end
    end
  end

  def create_authorization
    @authorization = SlackAuthorization.find_or_create_by(auth_id: @response.team.id)

    if @authorization.update(authorization_params)
      flash.notice = welcome? ? 'Welcome to CoderAlert!' : 'Slack successfully connected'
    else
      flash.alert = 'Slack authorization could not be saved'
      raise StandardError, 'Slack authorization could not be saved'
    end
  end

  def retrieve_access_token
    Slack::Web::Client.new.oauth_v2_access(oauth_params)
  end
end

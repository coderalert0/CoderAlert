class EditAlertSettingForm < BaseForm
  nested_attributes :alert, :slack_email, :slack_user_id, :alertable, to: :alert_setting

  accessible_attr :alert, :slack_email

  attr_accessor :alert_setting

  validate :slack_account_found

  def _submit
    alert_setting.save!
  end

  private

  def initialize(args = {})
    super args_key_first args, :alert_setting
  end

  def slack_account_found
    return unless alertable.is_a? SlackAuthorization

    begin
      client = Slack::Web::Client.new(token: alertable.access_token)
      response = client.users_lookupByEmail(email: slack_email)
      self.slack_user_id = response.user.id
    rescue StandardError => e
      Rails.logger.info e
      errors.add(:base, 'The Slack account associated with the email address could not be found')
    end
  end
end

class SmsClient
  def send_ticket_created_message
    AlertSetting.sms_alerts_on(@ticket).each do |alert_setting|
      @client.messages.create({
                                from: Rails.application.credentials.dig(:twilio, :twilio_phone_number),
                                to: alert_setting.alertable.value,
                                body: SMSDecorator.decorate(@ticket).ticket_created_sms_message
                              })
    rescue StandardError => e
      Rails.logger.error e
    end
  end

  private

  def initialize(ticket)
    @ticket = ticket
    @client = Twilio::REST::Client.new
  end
end

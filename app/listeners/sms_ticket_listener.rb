class SMSTicketListener
  def on_ticket_created(ticket)
    AlertSetting.sms_alerts_on(ticket.project).each do |alert_setting|
      client.messages.create({
                               from: Rails.application.credentials.dig(:twilio, :twilio_phone_number),
                               to: alert_setting.alertable.value,
                               body: SMSDecorator.decorate(ticket).ticket_created_sms_message
                             })
    rescue StandardError => e
      Rails.logger.error e
    end
  end

  private

  def client
    Twilio::REST::Client.new
  end
end

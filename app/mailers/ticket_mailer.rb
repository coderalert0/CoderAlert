class TicketMailer < ApplicationMailer
  before_action :load_resources

  def ticket_created
    return unless receipient_email_addresses.present?

    mail(to: receipient_email_addresses, subject: @ticket.created_subject)
  end

  def ticket_updated
    return unless receipient_email_addresses.present?

    mail(to: receipient_email_addresses, subject: @ticket.updated_subject)
  end

  private

  def load_resources
    @content = params[:content]
    @ticket =  TicketMailerDecorator.decorate(params[:ticket])
  end

  # DRY it
  def receipient_email_addresses
    AlertSetting.email_alerts_on(@ticket)
                .map { |ce| %("#{ce.alertable.user.decorate.full_name}" <#{ce.alertable.value}>) }
  end
end

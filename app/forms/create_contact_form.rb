class CreateContactForm < BaseForm
  attr_writer :contact

  nested_attributes :type, :value, :alerts, :user, to: :contact

  accessible_attr :type, :value, :alerts

  def contact
    @contact ||= Contact.new
  end

  def _submit
    ActiveRecord::Base.transaction do
      contact.save!

      user.projects.each do |project|
        alert_setting = AlertSetting.find_or_create_by(alertable: contact, user: user, project: project)
        alert_setting.update(alert: alerts)
      end
    end
  end

  private

  def initialize(args = {})
    super args_key_first args, :contact
  end
end

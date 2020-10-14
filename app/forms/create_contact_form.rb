class CreateContactForm < BaseForm
  attr_writer :contact
  attr_accessor :alerts

  nested_attributes :type, :value, :user, to: :contact

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

class CreateContactForm < BaseForm
  attr_writer :contact
  attr_accessor :alerts

  nested_attributes :type, :value, :user, to: :contact

  accessible_attr :type, :value, :alerts

  validates_presence_of :alerts, if: proc { |record| record.class == CreateContactForm }

  def contact
    @contact ||= Contact.new
  end

  def _submit
    ActiveRecord::Base.transaction do
      contact = Contact.find_or_create_by(type: self.contact.type, value: self.contact.value, user: self.contact.user)

      user.projects.each do |project|
        alert_setting = AlertSetting.find_or_create_by(alertable: contact.becomes!(type.constantize),
                                                       user: user,
                                                       project: project)

        alert_setting.update(alert: alerts) if alerts.present?
      end
    end
  end

  private

  def initialize(args = {})
    super args_key_first args, :contact
  end
end

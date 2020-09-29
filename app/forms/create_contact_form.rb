class CreateContactForm < BaseForm
  attr_writer :contact

  nested_attributes :type, :value, :alerts, :user, to: :contact

  accessible_attr :type, :value, :alerts

  def contact
    @contact ||= Contact.new
  end

  def _submit
    contact.save!
  end

  private

  def initialize(args = {})
    super args_key_first args, :contact
  end
end

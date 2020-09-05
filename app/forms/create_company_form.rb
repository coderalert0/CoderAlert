class CreateCompanyForm < BaseForm
  attr_accessor :name
  attr_writer :company

  nested_attributes :name, to: :company

  accessible_attr :name

  def company
    @company ||= Company.new
  end

  def _submit
    company.save!
  end
end

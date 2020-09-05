class CreateProjectForm < BaseForm
  attr_accessor :name, :company
  attr_writer :project

  nested_attributes :name, :company, to: :project

  accessible_attr :name

  def project
    @project ||= Project.new
  end

  def _submit
    project.save!
  end

  private

  def initialize(args = {})
    self.company = args[:company]
    super
  end
end
